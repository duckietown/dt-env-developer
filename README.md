# `dt-env-developer`

This "environment" repository contains pointers to the most important repositories in Duckietown. 

These are managed using a tool called [`mr`][mr].

Here we describe how to get started with the development workflow on the `ente-staging` distribution.

# Requirements

## Install tools

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

Let’s clone the `ente-staging` branch.

``` 
git clone -b ente-staging git@github.com:duckietown/dt-env-developer ./ente-staging
cd ./ente-staging
```

## Setup `direnv`

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

> **NOTE:**  You might not have permissions to access some of the repos. Ask your manager.

### Complete docs

[See here for the complete documentation about ](http://myrepos.branchable.com/)`mr`.



# Setup shell

Switch your shell to `ente` by running the following command,

``` 
dts --set-version ente-staging
```

# Keeping track of daffy VS ente

Jenkins is setup to constantly check for repositories for which the `daffy` branch moves ahead wrt the `ente` branch. The idea is that every bug fix implemented in `daffy` should be ported to `ente` (the opposite is not true).
