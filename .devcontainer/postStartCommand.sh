#!/bin/bash

# Install duckietown-shell
pipx install duckietown-shell

# Start dbus daemon
sudo dbus-daemon --system --fork

# Start avahi daemon
sudo avahi-daemon -D

# Docker credentials fix
export DOCKER_CONFIG="$(mktemp -d)"
printf '{}' > "$DOCKER_CONFIG/config.json"

# Add DOCKER_CONFIG to ~/.bashrc for persistent access
echo "export DOCKER_CONFIG=\"$DOCKER_CONFIG\"" >> ~/.bashrc