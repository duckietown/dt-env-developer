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

# Check if development mode is enabled and run direnv allow
if [ "${ENABLE_DEVELOPMENT_MODE}" = "true" ]; then
	echo "Development mode enabled. Setting up direnv..."
	
	# Add direnv hook to bashrc if not already present
	if ! grep -q 'eval "$(direnv hook bash)"' ~/.bashrc; then
		echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
		echo "Direnv hook added to ~/.bashrc"
	fi
	
	# Run direnv allow
	cd /workspaces/dt-env-developer && direnv allow
	echo "Direnv setup complete."
else
	echo "Development mode not enabled (set ENABLE_DEVELOPMENT_MODE=true in .devcontainer/.env to enable)."
	
	# Remove direnv hook from ~/.bashrc if present
	if grep -q 'eval "$(direnv hook bash)"' ~/.bashrc; then
		sed -i '/eval "$(direnv hook bash)"/d' ~/.bashrc
		echo "Direnv hook removed from ~/.bashrc"
	fi
fi

echo "Setup complete. Please open a new terminal."