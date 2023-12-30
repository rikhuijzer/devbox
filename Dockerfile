FROM ubuntu:22.04

RUN set -eux; \
    apt-get update && \
    apt-get -y install sudo; \
    adduser --disabled-password dev; \
    adduser dev sudo; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dev
WORKDIR /home/dev

RUN set -eux; \
    sudo apt-get update; \
    sudo apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        fish \
        fzf \
        git \
        gnupg \
        htop \
        jq \
        make \
        ncdu \
        openssh-client \
        ninja-build \
        python3 \
        python3-pip \
        ranger \
        ripgrep \
        unzip \
        wget \
        wget \
        xclip \
        zip \
    ; \
    pip3 install --upgrade pip; \
    pip3 install -U \
        setuptools \
        wheel \
    ; \
    mkdir -p /home/dev/git; \
    mkdir -p /home/dev/.config/fish; \
    mkdir -p /home/dev/.config/nvim; \
    sudo rm -rf /var/lib/apt/lists/*

COPY config.fish /home/dev/.config/fish/config.fish

ENV XDG_CONFIG_HOME /home/dev/.config
ENV XDG_DATA_HOME /home/dev/.local/share

# Using nix for some non-x86 binaries.
RUN curl -L https://nixos.org/nix/install -o install; \
    sh ./install; \
    rm install;

ENV PATH=/home/dev/.nix-profile/bin:$PATH

RUN nix-env -iA nixpkgs.neovim; \
    nix-env -iA nixpkgs.nodejs

COPY init.vim /home/dev/.config/nvim/init.vim

RUN set -eux; \
    sh -c 'curl -fLo "/home/dev/.config/nvim/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';

RUN nvim --headless +PlugInstall +qall; \
    timeout 1m nvim --headless +CocInstall; exit 0

CMD ["fish"]
