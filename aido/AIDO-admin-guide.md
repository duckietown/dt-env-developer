AI-DO admin guide
=================

This guide contains notes for the admins to make sure everything is done correctly.


## Chain of dependencies


`duckietown-challenges`: bump-upload. Note version.

`duckietown-shell`: update version of `duckietown-challenges` in setup.py and requirements.txt.
Do `make bump-upload`.

`duckietown-shell-commands`: define minimum version of `duckietown-shell`.

`duckietown-challenges-runner`: build without cache


Re-create the base container: 

    make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/ build-no-cache push



## Define challenges

Run the tester guide without the DTSERVER variable.


## Remember to commit any local changes to branches


Make sure the following are up to date:

	git -C ${DT_ENV_DEVELOPER}/src/duckietown-challenges status
	git -C ${DT_ENV_DEVELOPER}/src/zuper_nodes status
	git -C ${DT_ENV_DEVELOPER}/src/zuper_json status
	git -C ${DT_ENV_DEVELOPER}/src/zuper_json status
	git -C ${DT_ENV_DEVELOPER}/src/aido-protocols status

## Base images

Two base images: `gym-duckietown` and base `aido2-base-python3`.

Re-build the base images:

    make build-base-containers

Push the base images: 

    make push-base-containers

