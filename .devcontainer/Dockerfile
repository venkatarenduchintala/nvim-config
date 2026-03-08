FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV TZ=Europe/Zurich
ENV LANG=de_CH.UTF-8
ENV LC_ALL=de_CH.UTF-8
ENV LANGUAGE=de_CH:de:en

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bash \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        fd-find \
        file \
        g++ \
        gcc \
        gettext \
        git \
        less \
        libtool \
        libtool-bin \
        locales \
        make \
        ninja-build \
        nodejs \
        npm \
        openjdk-17-jdk-headless \
        pkg-config \
        procps \
        python3 \
        python3-pip \
        python3-venv \
        ripgrep \
        sudo \
        tzdata \
        unzip \
        xz-utils \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && printf 'de_CH.UTF-8 UTF-8\n' > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=${LANG} LC_ALL=${LC_ALL} \
    && git clone --depth 1 --branch stable https://github.com/neovim/neovim /tmp/neovim \
    && make -C /tmp/neovim CMAKE_BUILD_TYPE=Release \
    && make -C /tmp/neovim install \
    && python3 -m pip install --no-cache-dir --break-system-packages pynvim \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && mkdir -p /workspace/nvim-config /home/${USERNAME}/.config /home/${USERNAME}/.cache/nvim /home/${USERNAME}/.local/share/nvim /home/${USERNAME}/.local/state/nvim \
    && chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME} \
    && rm -rf /tmp/neovim /var/lib/apt/lists/*

USER ${USERNAME}
WORKDIR /workspace/nvim-config
