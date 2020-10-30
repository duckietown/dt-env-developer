AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple
DT_ENV_DEVELOPER ?= .

all:

.PHONY: ci build define-challenges templates baselines

aido: ci build define-challenges templates baselines


bases: lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-base-python3 build push


ci: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-submission-ci-test build push

templates:  \
	template-pytorch \
	template-random \
	template-ros \
	template-tensorflow

templates-ONLY:  \
	template-pytorch-ONLY \
	template-random-ONLY \
	template-ros-ONLY \
	template-tensorflow-ONLY

template-pytorch: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-pytorch build push submit-bea

template-random: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-random build push  submit-bea

template-ros: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-ros build push submit-bea

template-tensorflow: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-tensorflow build push  submit-bea


template-pytorch-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-pytorch build push submit-bea

template-random-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-random build push  submit-bea

template-ros-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-ros build push submit-bea

template-tensorflow-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-tensorflow build push  submit-bea

baselines: \
	baseline-duckietown \
	baseline-minimal-agent \
	baseline-minimal-agent-full

baselines-ONLY: \
	baseline-duckietown-ONLY \
	baseline-minimal-agent-ONLY \
	baseline-minimal-agent-full-ONLY
	#	baseline-JBR

	# baseline-tensorflow-IL-logs \
	# baseline-tensorflow-IL-sim \
	# baseline-pytorch \

baseline-tensorflow-IL-logs: bases template-tensorflow define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-logs-tensorflow submit-bea

baseline-tensorflow-IL-sim: bases template-tensorflow define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-sim-tensorflow  submit-bea

baseline-pytorch: bases template-pytorch define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RL-sim-pytorch  submit-bea

baseline-JBR: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-JBR  submit-bea

baseline-duckietown: bases define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  submit-bea

baseline-minimal-agent: bases lib-aido-analyze lib-aido-agents define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  submit-bea

baseline-minimal-agent-full: bases  lib-aido-analyze lib-aido-agents define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  submit-bea


baseline-tensorflow-IL-logs-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-logs-tensorflow submit-bea

baseline-tensorflow-IL-sim-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-sim-tensorflow  submit-bea

baseline-pytorch-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RL-sim-pytorch  submit-bea

baseline-JBR-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-JBR  submit-bea

baseline-duckietown-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  submit-bea

baseline-minimal-agent-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  submit-bea

baseline-minimal-agent-full-ONLY:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  submit-bea








other: define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full submit-bea

build-minimal-agent-full:
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full build push


define-challenges: define-LF define-multistep define-prediction define-robotarium

define-LF: build-scenario-maker  build-simulator-gym  build-experiment_manager build-minimal-agent-full build-duckietown-challenges-cli
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF define-challenge

build-scenario-maker: bases lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-scenario_maker build push

build-gym-duckietown: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/gym-duckietown build push

build-simulator-gym: build-gym-duckietown lib-duckietown-gym lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-simulator-gym build push

define-multistep: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-multistep define-challenge

define-prediction: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-prediction define-challenge

define-robotarium: define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-robotarium-evaluation-form define-challenge


build: \
	build-gym-duckietown \
	build-scenario-maker \
	build-simulator-gym \
	build-mooc-fifos-connector\
	build-aido-submission-ci-test\
	build-experiment_manager \
	build-duckietown-challenges-cli \
	build-duckietown-challenges-runner \
	build-minimal-agent-full \
	build-server


build-experiment_manager: bases lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-experiment_manager  build push




build-aido-submission-ci-test: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-submission-ci-test  build push

build-mooc-fifos-connector: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/mooc-fifos-connector  build push

build-duckietown-challenges-cli: lib-duckietown-challenges-runner lib-duckietown-challenges lib-duckietown-docker-utils lib-duckietown-build-utils
	echo REMOVED TMP
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-cli  build push


build-duckietown-challenges-runner: lib-duckietown-challenges lib-duckietown-challenges-runner
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner build push

# note: build the evaluator first so that the servers can update before the server
build-server: lib-duckietown-challenges lib-duckietown-challenges-runner lib-duckietown-tokens build-duckietown-challenges-runner
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-server build push

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


lib-aido-agents:
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


mooc: mooc-fifos-connector

mooc-fifos-connector: bases
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/mooc-fifos-connector build push

#update-baselines-circleci:
#	./update-circleci-baselines.sh



root-images:
	docker pull docker.io/ubuntu:20.04
	docker tag  docker.io/ubuntu:20.04 ${AIDO_REGISTRY}/ubuntu:20.04
	docker push ${AIDO_REGISTRY}/ubuntu:20.04

	docker pull docker.io/python:3.8
	docker tag  docker.io/python:3.8 ${AIDO_REGISTRY}/python:3.8
	docker push ${AIDO_REGISTRY}/python:3.8

	docker pull docker.io/pytorch/pytorch
	docker tag  docker.io/pytorch/pytorch ${AIDO_REGISTRY}/pytorch/pytorch
	docker push ${AIDO_REGISTRY}/pytorch/pytorch
