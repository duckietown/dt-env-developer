

all:
	cat Makefile.instructions.txt


build-base-containers: build-aido-base-container build-gym-base-container

define-challenges: define-challenge-prediction define-challenge-aido_LF define-challenge-amod


define-challenge-amod:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-aido_amod define-challenge

make-submissions: make-submissions-prediction make-submissions-aido_LF make-submissions-aido_amod


make-submissions-aido_amod: make-submissions-aido_amod-java make-submissions-aido_amod-python


make-submissions-aido_amod-java:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-aido_amod-template-java submit

make-submissions-aido_amod-python:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-aido_amod-template-python submit

push-base-containers: push-gym-base-container  push-aido-base-container

make-submissions-prediction: make-submissions-prediction-mean make-submissions-prediction-random  make-submissions-prediction-last

make-submissions-prediction-mean:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-prediction/predictor_mean submit

make-submissions-prediction-random:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-prediction/predictor_random submit

make-submissions-prediction-last:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-prediction/predictor_last submit

make-submissions-aido_LF:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-aido_LF/minimal_agent submit


# AIDO 2 base container

build-aido-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ build

build-aido-base-container-no-cache:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ build-no-cache

push-aido-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ push

# Gym base container

build-gym-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/gym-duckietown build-docker-python3

push-gym-base-container:
	make -C ${DT_ENV_DEVELOPER}/src/aido-protocols/minimal-nodes-stubs/aido2-base-python3/ push

define-challenge-aido_LF:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-aido_LF define-challenge

define-challenge-prediction:
	make -C ${DT_ENV_DEVELOPER}/aido/challenge-prediction define-challenge




