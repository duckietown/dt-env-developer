DOCKER_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple
DT_ENV_DEVELOPER ?= .

all:


templates:  \
	template-random \
	template-ros \
	template-pytorch \
	template-tensorflow

agents: \
	agent-minimal-agent-state  \
	agent-minimal-agent-full  \
	agent-baseline-simple-yield



agent-minimal-agent-full: build-aido-base-python3  lib-aido-analyze lib-aido-agents
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full build



baselines: \
	baseline-RL-sim-pytorch \
	baseline-duckietown \
	baseline-behavior-cloning \
	baseline-JBR \
	baseline-RPL-ros \
	baseline-dagger-pytorch \
	baseline-duckietown-ml \
	baseline-minimal-agent \
	baseline-minimal-agent-full \
	baseline-minimal-agent-state \
	baseline-simple-yield



aido: build-aido-submission-ci-test libs build define-challenges templates baselines


build-aido-base-python3: lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-base-python3 build


build-aido-submission-ci-test: build-aido-base-python3 lib-duckietown-docker-utils
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-submission-ci-test build

define-LF-before-subs: define-LF
	echo "Uncomment above to first do all definitions"

template-pytorch: build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-pytorch build submit-bea

template-random: build-aido-base-python3 define-LF-before-subs lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-random build  submit-bea

template-ros: build-aido-base-python3 define-LF-before-subs lib-aido-protocols dt-ros-commons
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-ros build submit-bea

template-tensorflow: build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-tensorflow build  submit-bea

dt-base-environment:
	dts devel build -C  $(DT_ENV_DEVELOPER)/src/dt-base-environment --arch amd64 --push

dt-commons: dt-base-environment
	dts devel build -C  $(DT_ENV_DEVELOPER)/src/dt-commons --arch amd64 --push

dt-ros-commons: dt-commons
	dts devel build -C  $(DT_ENV_DEVELOPER)/src/dt-ros-commons --arch amd64 --push

dt-core: dt-ros-commons
	dts devel build -C  $(DT_ENV_DEVELOPER)/src/dt-core --arch amd64 --push

dt-car-interface: dt-ros-commons
	dts devel build -C  $(DT_ENV_DEVELOPER)/src/dt-ros-commons --arch amd64 --push

baseline-duckietown: build-aido-base-python3 define-LF-before-subs dt-car-interface template-ros dt-core
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  build submit-bea

baseline-duckietown-ml: build-aido-base-python3 define-LF-before-subs  build-dt-machine-learning-base-environment baseline-duckietown  dt-car-interface dt-core
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown-ml  submit-bea



baseline-JBR:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-JBR submit-bea


baseline-RL-sim-pytorch:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RL-sim-pytorch submit-bea

baseline-dagger-pytorch:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-dagger-pytorch submit-bea


# does not depend on the base but has same deps

baseline-behavior-cloning:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-behavior-cloning submit-bea


baseline-RPL-ros:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RPL-ros submit-bea

baseline-pytorch: build-aido-base-python3 template-pytorch define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RL-sim-pytorch  submit-bea

baseline-JBR: build-aido-base-python3 define-LF-before-subs template-tensorflow
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-JBR  submit-bea

#
#FROM ${DOCKER_REGISTRY}/duckietown/challenge-aido_lf-baseline-duckietown:${BASE_TAG} AS baseline
#
#FROM ${DOCKER_REGISTRY}/duckietown/dt-machine-learning-base-environment:${BASE_TAG} AS base
#
#WORKDIR /code
#
#COPY --from=baseline ${CATKIN_WS_DIR}/src/dt-car-interface ${CATKIN_WS_DIR}/src/dt-car-interface
#
#COPY --from=baseline ${CATKIN_WS_DIR}/src/dt-core ${CATKIN_WS_DIR}/src/dt-core

build-baseline-duckietown: build-aido-base-python3
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  build submit-bea

baseline-minimal-agent: build-aido-base-python3 lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  build submit-bea

baseline-minimal-agent-full: build-aido-base-python3  lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full submit-bea

agent-minimal-agent-state: build-aido-base-python3  lib-aido-analyze lib-aido-agents
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-state build

baseline-minimal-agent-state: build-aido-base-python3  lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-state submit-bea


agent-baseline-simple-yield: build-aido-base-python3  lib-aido-analyze lib-aido-agents
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-simple-yield  build



baseline-simple-yield: build-aido-base-python3  lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-simple-yield submit-bea


baseline-challenge-aido_LF-minimal-agent-full: build-aido-base-python3 lib-aido-agents lib-duckietown-world define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full  submit-bea


define-challenges: define-LF define-multistep define-prediction define-robotarium

define-LF: build-scenario-maker  build-simulator-gym  build-challenge-aido_LF-experiment_manager  build-duckietown-challenges-cli agents
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF define-challenge

build-scenario-maker: build-aido-base-python3 lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-scenario_maker build

build-gym-duckietown: build-aido-base-python3 lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/gym-duckietown build

build-simulator-gym: build-gym-duckietown lib-duckietown-gym lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-simulator-gym upload build

define-multistep: build-aido-base-python3
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-multistep define-challenge

define-prediction: build-aido-base-python3
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-prediction define-challenge

define-robotarium: define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-robotarium-evaluation-form define-challenge

define-collision: define-LF
	$(MAKE) -C class/dt-exercises/collision-solution rebuild

build: \
	build-gym-duckietown \
	build-scenario-maker \
	build-simulator-gym \
	build-aido-submission-ci-test\
	build-challenge-aido_LF-experiment_manager \
	build-duckietown-challenges-cli \
	build-duckietown-challenges-runner \
	build-server


build-challenge-aido_LF-experiment_manager: build-aido-base-python3 \
	lib-aido-protocols lib-aido-analyze lib-duckietown-world lib-duckietown-challenges
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-experiment_manager upload  build


build-dt-machine-learning-base-environment:  lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/dt-machine-learning-base-environment  build



build-duckietown-challenges-cli: lib-duckietown-challenges-runner lib-duckietown-challenges \
	lib-duckietown-docker-utils lib-duckietown-build-utils
	# echo REMOVED TMP
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-cli build


build-duckietown-challenges-runner: lib-duckietown-challenges lib-duckietown-challenges-runner \
	lib-duckietown-build-utils lib-duckietown-tokens lib-duckietown-docker-utils
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner build

# note: build the evaluator first so that the servers can update before the server
build-server: lib-duckietown-challenges lib-duckietown-challenges-runner lib-duckietown-tokens \
	build-duckietown-challenges-runner lib-duckietown-build-utils
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-server build

libs_targets=

libs: \
	lib-duckietown-build-utils \
	lib-aido-agents \
	lib-aido-analyze \
	lib-aido-protocols \
	lib-duckietown-gym \
	lib-duckietown-world \
	lib-duckietown-challenges \
	lib-duckietown-challenges-runner \
	lib-duckietown-tokens \
	lib-duckietown-docker-utils \
	lib-duckietown-aido-ros-bridge

lib-duckietown-build-utils:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-build-utils  upload

lib-duckietown-docker-utils:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-docker-utils  upload

lib-duckietown-aido-ros-bridge:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-aido-ros-bridge  upload


lib-aido-agents: lib-duckietown-world lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-agents upload

lib-aido-analyze:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-analyze upload

lib-aido-protocols:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-protocols upload

lib-duckietown-gym:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/gym-duckietown upload

lib-duckietown-world:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-world upload

lib-duckietown-challenges:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges upload

lib-duckietown-challenges-runner:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner upload

lib-duckietown-tokens:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-tokens upload



cloudflare:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-cloudflare-tunnel build

root-images:
	docker pull docker.io/library/ubuntu:20.04
	docker tag  docker.io/library/ubuntu:20.04 ${DOCKER_REGISTRY}/library/ubuntu:20.04
	docker push ${DOCKER_REGISTRY}/library/ubuntu:20.04

	docker pull docker.io/library/python:3.8
	docker tag  docker.io/library/python:3.8 ${DOCKER_REGISTRY}/library/python:3.8
	docker push ${DOCKER_REGISTRY}/library/python:3.8

	docker pull docker.io/pytorch/pytorch
	docker tag  docker.io/pytorch/pytorch ${DOCKER_REGISTRY}/pytorch/pytorch
	docker push ${DOCKER_REGISTRY}/pytorch/pytorch
