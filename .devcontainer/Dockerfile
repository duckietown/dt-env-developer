FROM mcr.microsoft.com/devcontainers/base:noble

# Add vscode user with same UID and GID as your host system
# (from https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user. 
USER $USERNAME

# Add user to video group to allow access to webcam
RUN sudo usermod --append --groups video $USERNAME

# Update all packages
RUN sudo apt-get update \
    && sudo apt-get install -y \
    avahi-utils \
    bumpversion \
    curl \
    direnv \
    dnsutils \
    fuse \
    git \
    inetutils-ping \
    iproute2 \
    libnss3-tools \
    libnss-mdns \
    mr \
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

# Install Firefox from Mozilla repository
ARG DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        ca-certificates wget gnupg lsb-release && \
    sudo install -d -m 0755 /etc/apt/keyrings && \
    wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg \
      | sudo gpg --dearmor -o /etc/apt/keyrings/packages.mozilla.org.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" \
      | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null && \
    echo 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' \
      | sudo tee /etc/apt/preferences.d/mozilla > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends firefox && \
    sudo rm -rf /var/lib/apt/lists/*

RUN echo 'export PIPX_BIN_DIR="$HOME/.local/bin"' >> ~/.bashrc \
    && echo 'export PATH="$PIPX_BIN_DIR:$PATH"' >> ~/.bashrc

# Install mutagen
RUN curl -sS https://webi.sh/mutagen | sh \
    && if [ -f ~/.config/envman/PATH.env ]; then . ~/.config/envman/PATH.env; fi

RUN mkdir -p /home/vscode/.local/bin
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
