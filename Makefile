DT_ENV_DEVELOPER ?= .

all:

	echo "Use 'make setup' to initialize the environment"

setup:
	$(MAKE) setup-develop-nodeps
	$(MAKE) setup-develop

setup-develop-nodeps:
	cd $(DT_ENV_DEVELOPER)/src/aido-agents && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/aido-analyze && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/aido-protocols && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-aido-ros-bridge && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-cli && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-server && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-docker-utils && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-serialization && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-shell && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-tokens && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-world && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/gym-duckietown   && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-build-utils && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-docker-utils && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/duckietown-utils && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-experiment_manager && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-simulator-gym && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/lib-dt-data-api && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/lib-dt-authentication && python3 setup.py develop --no-deps

setup-develop:
	cd $(DT_ENV_DEVELOPER)/src/aido-agents && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/aido-analyze && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/aido-protocols && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-aido-ros-bridge && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-cli && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-runner && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-challenges-server && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-docker-utils && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-serialization && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-shell && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-tokens && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-world && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/gym-duckietown   && python3 setup.py develop

	cd $(DT_ENV_DEVELOPER)/src/duckietown-build-utils && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-docker-utils && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/duckietown-utils && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-experiment_manager  && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/aido/challenge-aido_LF-simulator-gym && python3 setup.py develop
	cd $(DT_ENV_DEVELOPER)/src/lib-dt-authentication && python3 setup.py develop




template:
	PYENV_VERSION=3.8.8-z7-stage mr -j 4 run bash -c "zuper-cli template"
bump1:
	PYENV_VERSION=3.8.8-z7-stage mr -j 4 run bash -c "zuper-cli bump && zuper-cli upload"
bump1-push:
	PYENV_VERSION=3.8.8-z7-stage mr -j 4 run bash -c "zuper-cli bump && zuper-cli upload && git push --tags"
build-images:
	PYENV_VERSION=3.8.8-z7-stage mr -j 4 run bash -c "zuper-cli image-build"

build-images-slow:
	PYENV_VERSION=3.8.8-z7-stage mr  run bash -c "zuper-cli image-build"
aido-staging:
	z-make -o db-staging  AI-DO-5.mk
aido-staging2:
	PYENV_VERSION=3.8.8-z7-stage zmake -o db-staging  AI-DO-5.mk
aido-production:
	z-make -o db-production AI-DO-5.mk
aido-production2:
	PYENV_VERSION=3.8.8-z7-stage zmake -o db-production2  AI-DO-5.mk


images-transfer:
	docker pull circleci/python:3.7
	docker pull circleci/python:3.8
	docker pull circleci/python:3.9
	docker pull library/python:3.7
	docker pull library/python:3.8
	docker pull library/python:3.9

	docker tag circleci/python:3.7 ${DOCKER_REGISTRY}/circleci/python:3.7
	docker push ${DOCKER_REGISTRY}/circleci/python:3.7
	docker tag circleci/python:3.8 ${DOCKER_REGISTRY}/circleci/python:3.8
	docker push ${DOCKER_REGISTRY}/circleci/python:3.8
	docker tag circleci/python:3.9 ${DOCKER_REGISTRY}/circleci/python:3.9
	docker push ${DOCKER_REGISTRY}/circleci/python:3.9
	docker tag library/python:3.7 ${DOCKER_REGISTRY}/library/python:3.7
	docker push ${DOCKER_REGISTRY}/circleci/python:3.7
	docker tag library/python:3.8 ${DOCKER_REGISTRY}/library/python:3.8
	docker push ${DOCKER_REGISTRY}/circleci/python:3.8
	docker tag library/python:3.9 ${DOCKER_REGISTRY}/library/python:3.9
	docker push ${DOCKER_REGISTRY}/circleci/python:3.9


	docker pull library/ubuntu:20.04
	docker pull library/ubuntu:21.04
	docker pull library/ubuntu:21.10
	docker tag library/ubuntu:20.04 ${DOCKER_REGISTRY}/library/ubuntu:20.04
	docker push ${DOCKER_REGISTRY}/library/ubuntu:20.04
	docker tag library/ubuntu:21.04 ${DOCKER_REGISTRY}/library/ubuntu:21.04
	docker push ${DOCKER_REGISTRY}/library/ubuntu:21.04
	docker tag library/ubuntu:21.10 ${DOCKER_REGISTRY}/library/ubuntu:21.10
	docker push ${DOCKER_REGISTRY}/library/ubuntu:21.10


templates: \
	template-dt-images-onlydoc \
	template-submissions \
	template-dt-images-onlydoc-unittests

template_dt_image_onlydocs=templates/circle-dt-image-build-docs.yaml
template-dt-images-onlydoc: $(template_dt_image_onlydocs)
	cp $< src/dt-car-interface/.circleci/config.yml
	cp $< src/dt-duckiebot-interface/.circleci/config.yml
	cp $< src/dt-ros-commons/.circleci/config.yml
	cp $< src/dt-commons/.circleci/config.yml

template_dt_image_onlydocs=templates/circle-dt-image-build-docs-and-unittest.yaml
template-dt-images-onlydoc-unittests:  $(template_dt_image_onlydocs)
	cp $< src/dt-core/.circleci/config.yml

template_submission=templates/circle-aido-submission.yaml
template-submissions: $(template_submission)
	cp $<   aido/challenge-aido_LF-baseline-JBR/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-RL-sim-pytorch/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-RPL-ros/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-behavior-cloning/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-dagger-pytorch/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-duckietown/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-simple-yield/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-minimal-agent-full/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-minimal-agent-state/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-minimal-agent/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-template-pytorch/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-template-random/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-template-ros/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-template-tensorflow/.circleci/config.yml
	cp $<   aido/challenge-aido_LF-baseline-duckietown-ml/.circleci/config.yml



