

all:
	cat Makefile.instructions.txt


build-base-containers: build-aido2-base-container build-gym-base-container

define-challenges: define-challenge-prediction define-challenge-aido2_LF define-challenge-amod


define-challenge-amod:
	make -C ${DT_ENV_DEVELOPER}/aido1/challenge-aido1_amod1 define-challenge

make-submissions: make-submissions-prediction make-submissions-aido2_LF

push-base-containers: push-gym-base-container  push-aido2-base-container

make-submissions-prediction: make-submissions-prediction-mean make-submissions-prediction-random  make-submissions-prediction-last

make-submissions-prediction-mean:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-prediction/predictor_mean submit

make-submissions-prediction-random:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-prediction/predictor_random submit

make-submissions-prediction-last:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-prediction/predictor_last submit

make-submissions-aido2_LF:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-aido2_LF/minimal_agent submit


# AIDO 2 base container

build-aido2-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ build

build-aido2-base-container-no-cache:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ build-no-cache

push-aido2-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ push

# Gym base container

build-gym-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/gym-duckietown build-docker-python3

push-gym-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ push

define-challenge-aido2_LF:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-aido2_LF define-challenge

define-challenge-prediction:
	make -C ${DT_ENV_DEVELOPER}/aido2/challenge-prediction define-challenge




