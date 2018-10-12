# `duckietown-env-developer`

This "environment" repository contains pointers to the most important repositories in Duckietown. 

These are managed using a tool called [`mr`][mr].

## Install `mr`

Install `mr` on Linux:

    $ sudo apt install myrepos

Install `mr` on Mac:

    $ brew install mr

## Clone this repo

Clone this repository:

    $ git clone git@github.com:duckietown/duckietown-env-developer.git
    $ cd duckietown-env-developer

## Setup `mrtrust`


    $ echo $PWD/.mrconfig >> ~/.mrtrust

## Checkout

Check out all the repos:

    $ mr checkout

Note: you might not have permissions to access some of the repos.
Please notify us promptly---every time we add a repo, we need to update the permissions for particular groups.

## Status

You can check the status of the repos with this:

    $ mr status

This will tell you if you have modified files.

## Update  

Update:

    $ mr update


## Complete docs

[See here for the complete documentation about `mr`][docs].


[mr]: https://github.com/RichiH/myrepos
[docs]: http://myrepos.branchable.com/
