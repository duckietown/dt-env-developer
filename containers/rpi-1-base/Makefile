all:

build:
	# order is important
	env -u DOCKER_CONTENT_TRUST make -C rpi-duckiebot-raspberrypi3-python build

	# these are derived
	make -C rpi-duckiebot-loader build
	make -C rpi-duckiebot-online build
	make -C rpi-health build
	make -C rpi-simple-server build


build-no-cache:
	# order is important
	env -u DOCKER_CONTENT_TRUST  make -C rpi-duckiebot-raspberrypi3-python build-no-cache

	# these are derived
	make -C rpi-duckiebot-loader build-no-cache
	make -C rpi-duckiebot-online build-no-cache
	make -C rpi-health build-no-cache
	make -C rpi-simple-server build-no-cache



push:
	make -C rpi-duckiebot-raspberrypi3-python push
	make -C rpi-duckiebot-loader push
	make -C rpi-duckiebot-online push
	make -C rpi-health push
	make -C rpi-simple-server push

visualize:
	echo Run the following:
	echo dockviz images -t -l duckietown/rpi-duckiebot-raspberrypi3-python:master18

#└─dfcf24094cf1 Virtual Size: 487.8 MB Tags: duckietown/rpi-duckiebot-raspberrypi3-python:master18
#  ├─b1960ad7e32e Virtual Size: 487.8 MB Tags: duckietown/rpi-duckiebot-online:master18
#  ├─fbb09362ee07 Virtual Size: 487.8 MB Tags: duckietown/rpi-simple-server:master18
#  ├─092834961281 Virtual Size: 487.8 MB Tags: duckietown/rpi-health:master18
#  └─bfc19eaf5f14 Virtual Size: 487.8 MB Tags: duckietown/rpi-duckiebot-loader:master18
