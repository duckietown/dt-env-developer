# Duckietown Developer Guide for Claude

## Project Overview

Duckietown is a robotics development platform for:
- **Duckiebots** — ground-based autonomous vehicles
- **Duckiedrones** — aerial vehicles (DD21, DD24)

All code runs inside Docker containers using the **DTProject** standard. Primary tooling: Duckietown Shell (`dts`), Docker, ROS Noetic.

---

## Key Commands

```bash
# Discover robots on the network
dts fleet discover

# Build image locally (force rebuild)
dts devel build -f

# Build directly on a robot
dts devel build -f -H ROBOT_NAME

# Run locally
dts devel run

# Run on a robot with a specific launcher
dts devel run -H ROBOT_NAME -L launcher_name
```

Robots are accessible via `ROBOT_NAME.local` hostname resolution.

---

## DTProject Structure

```
my-project/
├── .dtproject              # Marks repo as a Duckietown Project (required)
├── Dockerfile              # ARG REPO_NAME, DESCRIPTION, MAINTAINER (fill placeholders)
├── configurations.yaml     # Docker container run configurations
├── packages/               # Python and Catkin packages
│   └── my_package/
│       ├── __init__.py
│       ├── src/            # ROS nodes (node files here)
│       ├── launch/         # ROS launch files
│       ├── config/         # YAML parameter files
│       └── CMakeLists.txt  # Only for Catkin (ROS) packages
├── launchers/              # Container entry points
│   └── default.sh          # Always wrap commands with `dt-exec` for signal handling
├── assets/                 # Static assets
├── dependencies-apt.txt    # System (APT) packages
├── dependencies-py3.txt    # Third-party Python packages
└── dependencies-py3.dt.txt # Duckietown Python packages
```

### Project Templates
- `template-basic` — Python only
- `template-ros` — ROS + Catkin
- `template-core` — ROS + Duckietown autonomous driving stack

### Launchers
Always use `dt-exec` inside launchers (handles SIGTERM/SIGINT properly):
```bash
#!/bin/bash
source /environment.sh
dt-exec roslaunch my_package my_node.launch
```

---

## ROS / DTROS Patterns

### Node Structure (mandatory pattern)
All ROS nodes **must** extend `DTROS` — never use bare `rospy.Node`.

```python
#!/usr/bin/env python3
from duckietown.dtros import DTROS, NodeType, TopicType, DTParam, ParamType
import rospy

class MyNode(DTROS):
    def __init__(self, node_name):
        super(MyNode, self).__init__(
            node_name=node_name,
            node_type=NodeType.PERCEPTION  # Choose appropriate type
        )

        # Parameters — no hardcoded defaults; use config YAML files
        self.my_param = DTParam('~my_param', param_type=ParamType.FLOAT)

        # Non-ROS attributes BEFORE subscribers/publishers
        self.some_state = 0.0

        # Subscribers (prefix: sub_)
        self.sub_img = rospy.Subscriber('image_rect', Image, self.cb_img, queue_size=1)

        # Publishers (prefix: pub_)
        self.pub_out = rospy.Publisher(
            'output_topic', Image, queue_size=1, dt_topic_type=TopicType.PERCEPTION
        )

    def cb_img(self, msg):  # Callbacks prefixed with cb_
        # Guard debug topics
        if self.pub_out.anybody_listening():
            self.pub_out.publish(msg)

    def on_shutdown(self):  # Always implement for graceful cleanup
        pass

if __name__ == '__main__':
    node = MyNode(node_name='my_node')
    rospy.spin()
```

### Node Types
`GENERIC` `DRIVER` `PERCEPTION` `CONTROL` `PLANNING` `LOCALIZATION` `MAPPING`
`SWARM` `BEHAVIOR` `VISUALIZATION` `INFRASTRUCTURE` `COMMUNICATION` `DIAGNOSTICS` `DEBUG`

### Naming Conventions
| Thing | Convention |
|---|---|
| Variables / functions | `snake_case` |
| Classes | `CamelCase` |
| Subscribers | `sub_topic_name` |
| Publishers | `pub_topic_name` |
| Callbacks | `cb_method_name` |
| Node file | `some_name_node.py` → class `SomeNameNode` |

### Config Files
Parameters live in `config/node_name/default.yaml` — **never** hardcode defaults in Python.

### Launch Files
```xml
<!-- launch/my_node.launch -->
<launch>
  <arg name="veh" default="$(env VEHICLE_NAME)"/>
  <group ns="$(arg veh)">
    <rosparam command="load" file="$(find my_package)/config/my_node/default.yaml"/>
    <node pkg="my_package" type="my_node.py" name="my_node" output="screen"/>
  </group>
</launch>
```

### Timing / Profiling
```python
with self.time_phase("processing step"):
    # code to profile
```

---

## Docker Image Hierarchy

```
ubuntu
└── duckietown/dt-base-environment    # Python 3, NumPy, ROS Noetic
    └── duckietown/dt-commons         # Duckietown libs, file handling, infra comms
        └── duckietown/dt-ros-commons # duckietown-utils, duckietown_msgs, DTROS
            ├── duckietown/dt-duckiebot-interface  # Camera, motors, LEDs drivers
            │   └── duckietown/dt-car-interface    # Kinematics, joystick mapping
            │       └── duckietown/dt-core         # Lane following, intersection control
            └── (simulation interfaces)
```

Inherit from the lowest layer that contains everything your project needs.

---

## Duckiedrone Development

The Duckiedrone stack is transitioning to the **Ente** release. For current hardware work, use the **Daffy** stack documentation:
- DD21: https://docs.duckietown.com/daffy/opmanual-duckiedrone/intro.html
- DD24: https://docs.duckietown.com/daffy/opmanual-dd24/

### Key Duckiedrone Services
| Service | Purpose |
|---|---|
| `pid-controller` | Flight control (altitude, attitude) |
| `state-estimator` | Fuses sensors for pose estimation |
| `visual-odometry` | Camera-based motion estimation |
| `mavlink-proxy` | MAVLink flight controller protocol bridge |
| `driver-tof` | Time-of-flight distance sensor |

---

## Code Style

- Formatter: **Black**
- No wildcard imports (`from module import *`)
- Only publish debug data when subscribers exist: `if self.pub_debug.anybody_listening():`
- Always implement `on_shutdown()` to release hardware, stop motors, close files
- Dependencies: pin versions in requirements files; rebuild image after changes

---

## VS Code Remote Development on Robot

```bash
# Create a Docker context pointing to the robot
docker context create ROBOT_NAME --docker "host=tcp://ROBOT_NAME.local:2375"
```

Then use the **Container Tools** extension to attach VS Code to a running container on the robot.

---

## Learning Experiences (LXs)

A Learning Experience is a self-contained pedagogical unit with Jupyter notebooks and robot code. Learners implement solutions in the `solution` package; instructors create LXs using the `lx` or `lx-recipe` templates.

### LX Structure
```
my-lx/
├── notebooks/          # Jupyter notebooks (work through sequentially)
├── packages/
│   └── solution/       # Learners write code here
└── README.md           # Learning goals documented here
```

### One-time Setup
```bash
dts setup mkcert        # SSL certificate setup (run once per machine)
```

### LX Development Workflow

```bash
# 1. Fork the LX repo on GitHub, then clone it
git clone https://github.com/YOUR_USERNAME/my-lx
cd my-lx
git remote add upstream https://github.com/duckietown/my-lx

# 2. Keep in sync with upstream
git pull upstream ente

# 3. Ensure correct profile
dts profile list        # should show 'ente' as active

# 4. Update tooling and robot
pipx upgrade duckietown-shell
dts update
dts desktop update
dts duckiebot update ROBOT_NAME

# 5. Launch the code editor (from LX root)
dts code editor

# 6. Build solution code
dts code build -R ROBOT_NAME
```

### Testing with a Virtual Robot (Duckiematrix)
```bash
# Create and start a virtual Duckiebot
dts duckiebot virtual create --type duckiebot --configuration DB21J VBOT_NAME
dts duckiebot virtual start VBOT_NAME

# Other virtual robot commands
dts duckiebot virtual list
dts duckiebot virtual stop VBOT_NAME

# Run LX against the simulator
dts code start_matrix

# Open workbench (ROS tools, keyboard control, image streams, RViz)
dts code workbench -m -R VBOT_NAME

# Open VNC viewer for the workbench desktop
dts code vnc
```

### Testing on a Physical Duckiebot
```bash
dts code workbench -R ROBOT_NAME
dts code vnc
```

### Available LX Templates
| Template | Use case |
|---|---|
| `lx` | Web-based learning experience |
| `lx-recipe` | Reusable LX component/recipe |

### Available LX Activity Types
| Activity | Description |
|---|---|
| Notebooks | Jupyter notebooks guiding concept and implementation |
| Workbench | VNC desktop with full ROS/Duckietown tooling |
| Simulation | Virtual Duckiebot in Duckiematrix |
| Real robot | Deploy and test on physical Duckiebot |

---

## Documentation Source
Full developer manual: `docs/books/duckietown-manual/src/70-developer-manual/`
Learning experiences: `docs/books/duckietown-manual/src/60-learning-experiences/`
