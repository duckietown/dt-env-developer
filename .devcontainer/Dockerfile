FROM ubuntu:24.04

# Add vscode user with same UID and GID as your host system
# (copied from https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create user or modify existing user
RUN apt-get update && apt-get install -y sudo \
    && if id $USER_UID >/dev/null 2>&1; then \
        # User with UID exists, modify it
        existing_user=$(getent passwd $USER_UID | cut -d: -f1) \
        && usermod -l $USERNAME -d /home/$USERNAME -m $existing_user \
        && groupmod -n $USERNAME $(getent group $USER_GID | cut -d: -f1) || true; \
    else \
        # Create new user
        groupadd --gid $USER_GID $USERNAME \
        && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# Switch from root to user
USER $USERNAME

# Add user to video group to allow access to webcam
RUN sudo usermod --append --groups video $USERNAME

# Update all packages
RUN sudo apt update && sudo apt upgrade -y

RUN sudo apt-get update \
    && sudo apt-get install -y \
    avahi-utils \
    bumpversion \
    curl \
    direnv \
    dnsutils \
    git \
    inetutils-ping \
    iproute2 \
    nano \
    net-tools \
    openssh-client \
    rsync \
    unzip \
    pipx \
    python3-venv \
    build-essential \
    gcc \
    python3-dev \
    && sudo rm -rf /var/lib/apt/lists/*

# Configure direnv shell hook and PATH
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc \
    && echo 'export PIPX_BIN_DIR="$HOME/.local/bin"' >> ~/.bashrc \
    && echo 'export PATH="$PIPX_BIN_DIR:$PATH"' >> ~/.bashrc

# Install mutagen
RUN curl -sS https://webi.sh/mutagen | sh \
    && . ~/.config/envman/PATH.env

RUN mkdir -p /home/vscode/.local/bin
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
