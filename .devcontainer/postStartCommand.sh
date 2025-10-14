#!/bin/bash

# Clear up /tmp directory
sudo rm -rf /tmp/*

# Configure mDNS for fast .local resolution
sudo sed -i 's/^hosts:.*/hosts: files mdns4_minimal [SUCCESS=return] mdns6_minimal [SUCCESS=return] dns/' /etc/nsswitch.conf
sudo grep -q "single-request-reopen" /etc/resolv.conf || sudo echo "options timeout:1 attempts:1 single-request-reopen" | sudo tee -a /etc/resolv.conf
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
if ! grep -q "export DOCKER_CONFIG=" ~/.bashrc; then
	echo "export DOCKER_CONFIG=\"$DOCKER_CONFIG\"" >> ~/.bashrc
fi

echo "Setup complete. Please open a new terminal."