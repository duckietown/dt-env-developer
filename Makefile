DT_ENV_DEVELOPER ?= .

all:

	echo "please see docs"


setup-develop-nodeps:
	cd $(DT_ENV_DEVELOPER)/src/aido-agents && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/aido-analyze && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/aido-protocols && python3 setup.py develop --no-deps
	cd $(DT_ENV_DEVELOPER)/src/aido-utils && python3 setup.py develop --no-deps
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

setup-develop:
	cd $(DT_ENV_DEVELOPER)/src/aido-agents && python3 setup.py develop 
	cd $(DT_ENV_DEVELOPER)/src/aido-analyze && python3 setup.py develop  
	cd $(DT_ENV_DEVELOPER)/src/aido-protocols && python3 setup.py develop  
	cd $(DT_ENV_DEVELOPER)/src/aido-utils && python3 setup.py develop  
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