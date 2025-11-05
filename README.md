# `dt-env-developer`


## Installation

### **On Linux**

Run the command,

```
sudo apt install myrepos direnv
```

### **On MacOS**

Run the command,

```
brew install mr direnv
```

## Install other tools

Install utility tools,

```
pip3 install bump2version twine
```

## Development Mode (VS Code Dev Container)

If you're using the VS Code dev container setup, you can enable **Development Mode** to automatically configure `direnv` when the container starts.

### Enabling Development Mode

1. Copy the environment template file:
   ```bash
   cp .devcontainer/.env.example .devcontainer/.env
   ```

2. Edit `.devcontainer/.env` and set:
   ```bash
   ENABLE_DEVELOPMENT_MODE=true
   ```

3. Rebuild or restart your dev container (VS Code Command Palette: "Dev Containers: Rebuild Container" or "Dev Containers: Rebuild and Reopen in Container")

### What Development Mode Does

When `ENABLE_DEVELOPMENT_MODE=true`:
- Automatically adds the `direnv` hook to your `~/.bashrc`
- Runs `direnv allow` on container startup to trust the workspace
- Sets up the development environment automatically

When `ENABLE_DEVELOPMENT_MODE=false` (default):
- You'll need to manually set up `direnv` (see "Setup `direnv`" section below)
- Useful if you want more control over your environment setup

> [!NOTE]
> The `.devcontainer/.env` file is gitignored to prevent accidentally committing local configuration.

# Setup the developer environment

All the repositories you will need to work with are indexed inside a repository called `dt-env-developer`.

Let’s clone the `ente` branch (the same applies to `ente-staging`).

```
git clone -b ente git@github.com:duckietown/dt-env-developer ./ente
cd ./ente
```

## Setup `direnv`

Hook `direnv` into your shell [REF](https://direnv.net/docs/hook.html)

**Using bash (Linux):**

Add the following line at the end of the `~/.bashrc` file:

```
eval "$(direnv hook bash)"
```

**Using zsh (macOS):**

Add the following line at the end of the `~/.zshrc` file:

```
eval "$(direnv hook zsh)"
```

We need to tell `direnv` that we trust this workspace,

```
direnv allow .
```

## Setup `mr`

We need to tell `mr` that we trust this workspace,

```
find "$(pwd)" -name '*.mrconfig' -print >> ~/.mrtrust
```

## Checkout

Check out all the repos:

```
mr checkout
```

> [!NOTE]
> **NOTE:** You might not have permissions to access some of the repos. Ask your manager.

### Complete docs

[See here for the complete documentation about](http://myrepos.branchable.com/) `mr`.

# Setup shell

Switch your shell to `ente` by running the following command,

```
dts --set-version ente
```

