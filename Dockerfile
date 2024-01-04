FROM ubuntu:22.04

RUN set -eux; \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        sudo \
    ; \
    adduser --disabled-password dev; \
    adduser dev sudo; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    echo 'deb [trusted=yes] http://apt.llvm.org/jammy/ llvm-toolchain-jammy main' >> /etc/apt/sources.list; \
    echo 'deb-src [trusted=yes] http://apt.llvm.org/jammy/ llvm-toolchain-jammy main' >> /etc/apt/sources.list; \
    echo 'deb [trusted=yes] http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main' >> /etc/apt/sources.list; \
    echo 'deb-src [trusted=yes] http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main' >> /etc/apt/sources.list; \
    sudo rm -rf /var/lib/apt/lists/*

USER dev
WORKDIR /home/dev

RUN set -eux; \
    sudo apt-get update; \
    sudo apt-get install -y --no-install-recommends \
        build-essential \
        clang-17 \
        clangd-17 \
        cmake \
        curl \
        doxygen \
        fish \
        git \
        gnupg \
        htop \
        jq \
        lld-17 \
        lsb-release \
        make \
        ncdu \
        ninja-build \
        openssh-client \
        python3-dev \
        python3-pip \
        python3-venv \
        ranger \
        software-properties-common \
        unzip \
        wget \
        wget \
        xclip \
        zip \
        zlib1g-dev \
    ; \
    sudo ln -s /usr/bin/clang-17 /usr/bin/clang; \
    sudo ln -s /usr/bin/clangd-17 /usr/bin/clangd; \
    sudo ln -s /usr/bin/clang++-17 /usr/bin/clang++; \
    sudo ln -s /usr/bin/lld-17 /usr/bin/lld; \
    sudo ln -s /usr/bin/python3 /usr/bin/python; \
    pip3 install --upgrade pip; \
    pip3 install -U \
        lit \
        matplotlib \
        numpy \
        pandas \
        pytest \
        pytest-xdist \
        scipy \
        setuptools \
        wheel \
    ; \
    mkdir -p /home/dev/git; \
    mkdir -p /home/dev/.config/fish; \
    mkdir -p /home/dev/.config/nvim; \
    sudo chsh -s /usr/bin/fish dev; \
    sudo rm -rf /var/lib/apt/lists/*

COPY config.fish /home/dev/.config/fish/config.fish

ENV XDG_CONFIG_HOME /home/dev/.config
ENV XDG_DATA_HOME /home/dev/.local/share

# Using nix for some newer and non-x86 binaries.
RUN curl -L https://nixos.org/nix/install -o install; \
    sh ./install; \
    rm install;

# ~/.local/bin is used by pip to install binaries.
ENV PATH=/home/dev/.nix-profile/bin:/home/dev/.local/bin:$PATH

RUN nix-env -iA nixpkgs.neovim; \
    nix-env -iA nixpkgs.nodejs; \
    nix-env -iA nixpkgs.ripgrep; \
    nix-env -iA nixpkgs.entr;

COPY init.vim /home/dev/.config/nvim/init.vim
COPY ee.sh /usr/bin/ee

RUN set -eux; \
    sh -c 'curl -fLo "/home/dev/.config/nvim/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'; \
    git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf; \
    ~/.fzf/install; \
    sudo chmod +x /usr/bin/ee;

RUN nvim --headless +PlugInstall +qall; \
    printf "\nWaiting 1 minute for CocInstall to finish..."; \
    timeout 1m nvim --headless +CocInstall; exit 0

CMD ["fish"]
