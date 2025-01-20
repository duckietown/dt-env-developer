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
make mrtrust-all
```

## Checkout

Check out all the repos:

```
$ mr checkout
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

## Devcontainer usage

This repository can be used as a devcontainer for development. This allows you to avoid installing anything on your local os. The only dependency is Docker. Follow the following steps to start the devcontainer:

> [!IMPORTANT]
> To utilize the full functionalities of the devcontainer (specifically host network) on macOS, you need to install `orbstack` rather than Docker. Follow the installation instructions [here](https://docs.orbstack.dev/quick-start).
> After installing `orbstack`, make sure it is running before opening the repository in a devcontainer.

### 1. Setup SSH Key Authentication

Ensure you have SSH key authentication set up with GitHub. You can follow the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

### 2. Enable SSH Agent Forwarding

Edit your `/etc/ssh/sshd_config` file to enable SSH agent forwarding. Add or modify the following lines:

```
AllowAgentForwarding yes
```

Restart the SSH service to apply the changes (**linux only**):

```
sudo systemctl restart sshd
```

### 3. Open the Repository in a Devcontainer


1. Open Visual Studio Code.
2. Install the "Remote - Containers" extension if you haven't already.
3. Open the repository folder in Visual Studio Code.
    > [!IMPORTANT]
    > If running on a linux host open the `.devcontainer/devcontainer.json` file and uncomment lines 13-14.

4. Download the dts module for the devcontainer by running:

        git submodule update --init .devcontainer/feature-dts-devcontainer

5. Press `F1` and select `Dev Containers: Rebuild and Reopen in Container`.


