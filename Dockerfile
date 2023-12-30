FROM ubuntu:22.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
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
        nodejs \
        openssh-client \
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
    curl -L https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.deb -o nvim-linux64.deb; \
        apt-get install -y ./nvim-linux64.deb; \
        rm -rf nvim-linux64.deb; \
    pip3 install --upgrade pip; \
    pip3 install -U \
        setuptools \
        wheel \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /usr/bin/fish dev
USER dev
WORKDIR /home/dev

RUN mkdir -p /home/dev/git; \
    mkdir -p /home/dev/.config/fish;

COPY config.fish /home/dev/.config/fish/config.fish

CMD ["fish"]
