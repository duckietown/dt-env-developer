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

