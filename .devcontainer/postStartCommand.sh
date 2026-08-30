#!/bin/bash

# Clear up /tmp directory
sudo rm -rf /tmp/duckietown/*

# Configure mDNS for fast .local resolution
sudo sed -i 's/^hosts:.*/hosts: files mdns4_minimal [SUCCESS=return] mdns6_minimal [SUCCESS=return] dns/' /etc/nsswitch.conf
sudo grep -q "single-request-reopen" /etc/resolv.conf || sudo echo "options timeout:1 attempts:1 single-request-reopen" | sudo tee -a /etc/resolv.conf
# Install duckietown-shell
pipx install duckietown-shell

# Start dbus daemon
sudo dbus-daemon --system --fork

# Start avahi daemon (idempotent: if a previous instance crashed and its pid got
# recycled, the stale pidfile blocks restart — clear it out first)
sudo pkill -x avahi-daemon 2>/dev/null || true
sudo rm -f /var/run/avahi-daemon/pid
sudo avahi-daemon -D

# Docker credentials fix
export DOCKER_CONFIG="$(mktemp -d)"
printf '{}' > "$DOCKER_CONFIG/config.json"

# Add DOCKER_CONFIG to ~/.zshrc for persistent access
if ! grep -q "export DOCKER_CONFIG=" ~/.zshrc; then
	echo "export DOCKER_CONFIG=\"$DOCKER_CONFIG\"" >> ~/.zshrc
fi

# Check if development mode is enabled and run direnv allow
if [ "${ENABLE_DEVELOPMENT_MODE}" = "true" ]; then
	echo "Development mode enabled. Setting up direnv..."
	
	# Add direnv hook to bashrc if not already present
	if ! grep -q 'eval "$(direnv hook zsh)"' ~/.zshrc; then
		echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
		echo "Direnv hook added to ~/.zshrc"
	fi
	
	# Run direnv allow
	cd /workspaces/dt-env-developer || { echo 'Error: Cannot change to workspace directory'; exit 1; }
	direnv allow
	echo "Direnv setup complete."
else
	echo "Development mode not enabled (set ENABLE_DEVELOPMENT_MODE=true in .devcontainer/.env to enable)."
	
	# Remove direnv hook from ~/.zshrc if present
	if grep -q 'eval "$(direnv hook zsh)"' ~/.zshrc; then
		sed -i '/eval "$(direnv hook zsh)"/d' ~/.zshrc
		echo "Direnv hook removed from ~/.zshrc"
	fi

	sudo rm -rf /tmp/vscode-ssh-auth-* # This is a workaround to disable SSH agent forwarding in devcontainers
	unset SSH_AUTH_SOCK
	eval "$(ssh-agent -s)"
	echo "SSH agent started. The container will not have access to your host's SSH keys."
fi

echo "Setup complete. Please open a new terminal."