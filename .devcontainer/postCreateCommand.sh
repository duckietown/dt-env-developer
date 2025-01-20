direnv allow /dt-env-developer
make mrtrust-all
mr checkout
# Build and install the duckietown_msgs packages
catkin_make --pkg duckietown_msgs --source /dt-env-developer/robot/dt-ros-commons/packages --build /home/vscode/build
. /dt-env-developer/devel/setup.bash