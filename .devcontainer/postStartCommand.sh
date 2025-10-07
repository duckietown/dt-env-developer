#!/bin/bash

# Install duckietown-shell
pipx install duckietown-shell
direnv allow /workspaces/*/.envrc


# Start dbus daemon
sudo dbus-daemon --system --fork

# Start avahi daemon
sudo avahi-daemon -D