AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple
DT_ENV_DEVELOPER ?= .

all:

aido: build-aido-submission-ci-test libs build define-challenges templates baselines mooc


build-aido-base-python3: lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/aido-base-python3 push


build-aido-submission-ci-test: build-aido-base-python3 lib-duckietown-docker-utils
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-submission-ci-test push

templates:  \
	template-random \
	template-ros \
	template-pytorch \
	template-tensorflow

define-LF-before-subs: # define-LF
	echo "Uncomment above to first do all definitions"

template-pytorch: build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-pytorch push submit-bea

template-random: build-aido-base-python3 define-LF-before-subs lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-random push  submit-bea

template-ros: build-aido-base-python3 define-LF-before-subs lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-ros push submit-bea

template-tensorflow: build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-template-tensorflow push  submit-bea

baselines: \
	baseline-duckietown \
	baseline-minimal-agent \
	baseline-minimal-agent-full \
	baseline-RPL-ros \
	baseline-behavior-cloning


# does not depend on the base but has same deps

baseline-behavior-cloning:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-behavior-cloning submit-bea


baseline-RPL-ros:  build-aido-base-python3 define-LF-before-subs build-dt-machine-learning-base-environment
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RPL-ros submit-bea

# baseline-tensorflow-IL-logs: build-aido-base-python3 template-tensorflow define-LF
# 	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-logs-tensorflow submit-bea

# baseline-tensorflow-IL-sim: build-aido-base-python3 template-tensorflow define-LF
# 	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-IL-sim-tensorflow  submit-bea

baseline-pytorch: build-aido-base-python3 template-pytorch define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-RL-sim-pytorch  submit-bea

baseline-JBR: build-aido-base-python3 define-LF-before-subs template-tensorflow
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-JBR  submit-bea

baseline-duckietown: build-aido-base-python3 define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  submit-bea
build-baseline-duckietown: build-aido-base-python3 
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-baseline-duckietown  push
baseline-minimal-agent: build-aido-base-python3 lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent  submit-bea

baseline-minimal-agent-full: build-aido-base-python3  lib-aido-analyze lib-aido-agents define-LF-before-subs
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full  submit-bea


build-challenge-aido_LF-minimal-agent-full: build-aido-base-python3 lib-aido-agents lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-minimal-agent-full push


define-challenges: define-LF define-multistep define-prediction define-robotarium

define-LF: build-scenario-maker  build-simulator-gym  build-challenge-aido_LF-experiment_manager build-challenge-aido_LF-minimal-agent-full build-duckietown-challenges-cli
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF define-challenge

build-scenario-maker: build-aido-base-python3 lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-scenario_maker push

build-gym-duckietown: build-aido-base-python3 lib-duckietown-world
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/gym-duckietown push

build-simulator-gym: build-gym-duckietown lib-duckietown-gym lib-aido-protocols
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-simulator-gym upload push


define-multistep: build-aido-base-python3
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-multistep define-challenge

define-prediction: build-aido-base-python3
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-prediction define-challenge

define-robotarium: define-LF
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/aido-robotarium-evaluation-form define-challenge


build: \
	build-gym-duckietown \
	build-scenario-maker \
	build-simulator-gym \
	build-mooc-fifos-connector\
	build-aido-submission-ci-test\
	build-challenge-aido_LF-experiment_manager \
	build-duckietown-challenges-cli \
	build-duckietown-challenges-runner \
	build-challenge-aido_LF-minimal-agent-full \
	build-server


build-challenge-aido_LF-experiment_manager: build-aido-base-python3 \
	lib-aido-protocols lib-aido-analyze lib-duckietown-world lib-duckietown-challenges
	$(MAKE) -C $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-experiment_manager upload  push


build-dt-machine-learning-base-environment:  lib-aido-protocols
	upload $(MAKE) -C $(DT_ENV_DEVELOPER)/src/dt-machine-learning-base-environment  push


build-mooc-fifos-connector: build-aido-base-python3
	echo "Removed for now"
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/mooc-fifos-connector  push

build-duckietown-challenges-cli: lib-duckietown-challenges-runner lib-duckietown-challenges \
	lib-duckietown-docker-utils lib-duckietown-build-utils
	# echo REMOVED TMP
	$(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-cli  push


build-duckietown-challenges-runner: lib-duckietown-challenges lib-duckietown-challenges-runner \
	lib-duckietown-build-utils lib-duckietown-tokens lib-duckietown-docker-utils
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner push

# note: build the evaluator first so that the servers can update before the server
build-server: lib-duckietown-challenges lib-duckietown-challenges-runner lib-duckietown-tokens \
	build-duckietown-challenges-runner lib-duckietown-build-utils
	# $(MAKE) -C $(DT_ENV_DEVELOPER)/src/duckietown-challenges-server push

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


mooc: build-mooc-fifos-connector

#update-baselines-circleci:
#	./update-circleci-baselines.sh



root-images:
	docker pull docker.io/library/ubuntu:20.04
	docker tag  docker.io/library/ubuntu:20.04 ${AIDO_REGISTRY}/library/ubuntu:20.04
	docker push ${AIDO_REGISTRY}/library/ubuntu:20.04

	docker pull docker.io/library/python:3.8
	docker tag  docker.io/library/python:3.8 ${AIDO_REGISTRY}/library/python:3.8
	docker push ${AIDO_REGISTRY}/library/python:3.8

	docker pull docker.io/pytorch/pytorch
	docker tag  docker.io/pytorch/pytorch ${AIDO_REGISTRY}/pytorch/pytorch
	docker push ${AIDO_REGISTRY}/pytorch/pytorch


dt-base-images:
	docker pull duckietown/dt-car-interface:daffy-amd64
	docker tag duckietown/dt-car-interface:daffy-amd64  ${AIDO_REGISTRY}/duckietown/dt-car-interface:daffy-amd64
	docker push ${AIDO_REGISTRY}/duckietown/dt-car-interface:daffy-amd64

	docker pull duckietown/dt-core:daffy-amd64
	docker tag duckietown/dt-core:daffy-amd64  ${AIDO_REGISTRY}/duckietown/dt-core:daffy-amd64
	docker push ${AIDO_REGISTRY}/duckietown/dt-core:daffy-amd64

