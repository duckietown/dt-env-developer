# Repository Guidelines

## Project Structure & Module Organization
- Root meta-repo: orchestrates development via `mr` (myrepos) and `direnv`.
- Key folders: `libraries/`, `robot/`, `infra/`, `compose/`, `autolab/`, `docs/`, `shell/`, `templates/`, `hardware/`, `lx/`, `matrix/`.
- Each folder contains a `.mrconfig` listing the actual child repositories and branches to clone. Example: `libraries/.mrconfig`.
- Assets and package templates live under `compose/`; ROS/autolab components under `autolab/`.

## Build, Test, and Development Commands
- `direnv allow .`: enable environment for this workspace.
- `make mrtrust-all`: trust all nested myrepos configurations (one time).
- `mr checkout`: clone all repositories declared in nested `.mrconfig` files.
- `mr update`: pull latest changes across all checked-out repositories.
- `dts --set-version ente`: switch the Duckietown Shell to the `ente` toolchain.
- Example: run a command in one repo
  - `mr -d libraries/lib-dtproject run "pytest -q"`

## Coding Style & Naming Conventions
- Follow per-repository style guides in each checked-out project.
- Shell scripts: bash, `set -euo pipefail`, kebab-case filenames (e.g., `protect-branches.sh`).
- YAML/JSON: 2-space indent; Python (where applicable): 4 spaces, `snake_case` modules and functions.
- Prefer small, focused scripts in `shell/` or within the specific child repo.

## Testing Guidelines
- Tests are defined per child repository (e.g., under `tests/` or language-specific defaults).
- Run tests from the target repo directory or via `mr -d <path> run <cmd>`.
- Aim for meaningful unit tests and basic integration checks before opening a PR.

## Commit & Pull Request Guidelines
- Reference Jira issue keys in branch names or PR titles; CI enforces pattern `DTSW-XXXX` (see `.github/workflows/jira-pr-check.yml`).
- Commits: concise, imperative subject; include scope when helpful. Example: `feat(libraries/lib-dtproject): add param validation`.
- PRs: clear description, link related issues, include screenshots/logs when relevant, and note any breaking changes.

## Security & Configuration Tips
- Do not commit secrets; prefer GitHub Secrets and `.env` managed by `direnv`.
- The script `protect-branches.sh` uses `gh` and `jq` to enforce branch protections across repos; run with `--dry-run` first.
- Keep local tool versions aligned with `dts --set-version ente` to avoid drift.

---

## Virtual Robot Development & Duckiematrix Workflow

This section documents the complete workflow for developing and deploying a DTProject on virtual Duckiebots using the Duckiematrix simulator.

### Architecture Overview

The data flow for a virtual robot is:

```
Duckiematrix renderer (Unity/Vulkan)
  → DTPS switchboard (inter-process message bus)
    → ROS2 bridge nodes (e.g., ros2-camera)
      → Your DTProject nodes (e.g., lane-following pipeline)
        → ROS2 bridge nodes (e.g., ros2-wheels)
          → DTPS switchboard
            → Duckiematrix actuators
```

Three layers of Docker stacks run on the virtual robot:

| Stack | Purpose | Key containers |
|---|---|---|
| `duckietown/duckiebot` | Core platform: DTPS switchboard, hardware drivers (camera, wheels, IMU, LEDs), bridges matrix↔DTPS | `dtps`, `driver-camera`, `driver-wheels`, `car-interface`, `kvstore` |
| `ros2/duckiebot` | ROS2 bridge layer: bridges DTPS↔ROS2 topics, provides Zenoh router | `zenoh-router`, `ros2-camera`, `ros2-wheels`, `ros2-imu`, `ros2-leds` |
| Your DTProject | Application code running via `dts devel run` | `dts-run-<project-name>` |

### Prerequisites

```bash
# One-time setup
dts --set-version ente
dts setup mkcert
```

### Step 1: Create and Start a Virtual Robot

```bash
# Create a virtual Duckiebot
dts duckiebot virtual create --type duckiebot --configuration DB21J ROBOT_NAME

# Start the virtual robot
dts duckiebot virtual start ROBOT_NAME

# Verify it's running
dts duckiebot virtual list
```

Other virtual robot commands:
```bash
dts duckiebot virtual stop ROBOT_NAME
dts duckiebot virtual restart ROBOT_NAME
dts duckiebot virtual destroy ROBOT_NAME
dts duckiebot virtual connect ROBOT_NAME   # terminal access
```

### Step 2: Set Up Docker Context

Create a Docker context to run docker commands against the virtual robot:

```bash
docker context create ROBOT_NAME --docker "host=tcp://ROBOT_NAME.local:2375"
```

Verify connectivity:
```bash
docker --context ROBOT_NAME ps
```

SSH access to the virtual robot uses user `duckie` with password `quackquack`.

### Step 3: Start the Platform Stacks

The stacks must be started in order. The `duckietown/duckiebot` stack provides the DTPS switchboard and hardware driver bridges. The `ros2/duckiebot` stack bridges DTPS topics to ROS2.

```bash
# Start the core platform stack (DTPS + drivers)
dts stack up -H ROBOT_NAME.local duckietown/duckiebot -d

# Start the ROS2 bridge stack (Zenoh + ROS2 bridges)
dts stack up -H ROBOT_NAME.local ros2/duckiebot -d
```

To stop stacks:
```bash
dts stack down -H ROBOT_NAME.local ros2/duckiebot
dts stack down -H ROBOT_NAME.local duckietown/duckiebot
```

### Step 4: Start the Duckiematrix Simulator

Run the Duckiematrix with a map. The `-S`/`--standalone` flag runs both the engine and renderer:

```bash
cd path/to/your-dtproject

# Run with a physical display (if available)
dts matrix run -S --embedded -m MAP_NAME --no-pull --no-tutorial

# Run headlessly over SSH (requires xvfb)
dts matrix run -S --embedded -m MAP_NAME --xvfb --no-pull --no-tutorial
```

**CRITICAL — Graphics API selection:**
- Default is Vulkan (`-force-vulkan`), which uses the GPU directly. This is correct and fast (~30 Hz camera).
- **Never use `--force-opengl` with `--xvfb`** — Xvfb only provides Mesa's llvmpipe software renderer for OpenGL, resulting in ~1 Hz instead of ~30 Hz.
- Vulkan bypasses X11/GLX entirely and accesses the NVIDIA GPU through the Vulkan ICD, even under Xvfb.

Key flags:
| Flag | Purpose |
|---|---|
| `-S, --standalone` | Run both engine and renderer |
| `--embedded` | Use embedded map as root directory |
| `-m, --map NAME` | Map directory name (e.g., `loop`) |
| `--xvfb` | Run headlessly under xvfb-run (Linux, SSH) |
| `--no-pull` | Skip pulling engine Docker image |
| `--no-tutorial` | Skip tutorial overlay |
| `-vv` | Verbose output |
| `-vk, --force-vulkan` | Force Vulkan (default on Linux — fast, uses GPU) |
| `-gl, --force-opengl` | Force OpenGL (slow under xvfb — avoid) |

### Step 5: Attach Robot to Matrix

After the matrix is running, attach your virtual robot to an entity in the simulation world:

```bash
dts matrix attach ROBOT_NAME MAP_NAME/ENTITY_NAME
```

Example:
```bash
dts matrix attach testbot map_0/vehicle_0
```

To detach:
```bash
dts matrix detach ROBOT_NAME
```

### Step 6: Build Your DTProject on the Robot

```bash
cd path/to/your-dtproject

# Build the Docker image on the virtual robot
dts devel build -f -H ROBOT_NAME
```

This syncs code and builds directly on the robot's Docker daemon.

### Step 7: Run Your DTProject

```bash
# Run with a specific launcher, host networking, and ROS_DOMAIN_ID
dts devel run -H ROBOT_NAME -L LAUNCHER_NAME --net host -- -e ROS_DOMAIN_ID=42

# Run in detached mode (add -d flag)
dts devel run -H ROBOT_NAME -L LAUNCHER_NAME --net host -d -- -e ROS_DOMAIN_ID=42
```

**CRITICAL — `ROS_DOMAIN_ID=42`:**
The ROS2 bridge stack uses `ROS_DOMAIN_ID=42`. Your DTProject container must use the same value, otherwise ROS2 nodes cannot discover each other. Pass it via `-- -e ROS_DOMAIN_ID=42` after the `dts devel run` arguments.

**Code-only changes (no rebuild needed):**
If you only changed Python code (not Dockerfile, dependencies, or CMakeLists), you can skip the build step. Just run `dts devel run` again — it syncs the code automatically via rsync before launching.

### Step 8: Verify the Pipeline

Use `ros2 topic hz` and `ros2 topic echo` inside the running container to verify data flow:

```bash
# Measure topic rate
docker --context ROBOT_NAME exec CONTAINER_NAME bash -c \
  'source /environment.sh && export ROS_DOMAIN_ID=42 && \
   ros2 topic hz /ROBOT_NAME/TOPIC_NAME --window 10'

# Echo a single message
docker --context ROBOT_NAME exec CONTAINER_NAME bash -c \
  'source /environment.sh && export ROS_DOMAIN_ID=42 && \
   ros2 topic echo /ROBOT_NAME/TOPIC_NAME MSG_TYPE --once'

# List all topics
docker --context ROBOT_NAME exec CONTAINER_NAME bash -c \
  'source /environment.sh && export ROS_DOMAIN_ID=42 && \
   ros2 topic list'
```

### Monitoring & Debugging

```bash
# Check container logs
docker --context ROBOT_NAME logs --tail 50 CONTAINER_NAME

# Check all running containers
docker --context ROBOT_NAME ps --format "{{.Names}}: {{.Status}}"

# Check GPU utilization (should be >0% when matrix is running with Vulkan)
nvidia-smi

# Check the duckiematrix renderer process
pgrep -a duckiematrix

# Check the Unity Player.log for renderer info
cat ~/.config/unity3d/Duckietown/Duckiematrix/Player.log | grep -i "renderer\|device"
```

### ROS2 Topic Naming Conventions

In ROS2 with `PushRosNamespace`, topic resolution differs from ROS1:

- **ROS1**: `~topic` resolves to `/<namespace>/<node_name>/topic`
- **ROS2**: relative topics resolve to `/<namespace>/topic` (no node-name prefix)

This means:
- The camera publishes to `/<veh>/image/compressed` (not `/<veh>/camera_node/image/compressed`)
- Cross-node remappings use the bare topic name: `("lineseglist_in", "segment_list")` not `("lineseglist_in", "line_detector_node/segment_list")`

### ROS2 Launch File Pattern

```python
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, GroupAction
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node, PushRosNamespace

def generate_launch_description() -> LaunchDescription:
    veh = LaunchConfiguration("veh")
    return LaunchDescription([
        DeclareLaunchArgument("veh", default_value="default_robot"),
        GroupAction([
            PushRosNamespace(veh),
            Node(
                package="my_package",
                executable="my_node.py",
                name="my_node",
                # Do NOT set namespace=veh here — PushRosNamespace handles it
                output="screen",
                parameters=[{"param": "value"}],
                remappings=[
                    # Use bare topic names, not node_name/topic
                    ("input_topic", "source_topic"),
                ],
            ),
        ]),
    ])
```

### ROS2 Launcher Script Pattern

```bash
#!/bin/bash
source /environment.sh
# Use ros2 launch (not roslaunch)
dt-exec ros2 launch my_package my_launch.launch.py veh:="${VEHICLE_NAME}"
```

### Common Issues & Solutions

| Problem | Cause | Solution |
|---|---|---|
| Camera at ~1 Hz instead of ~30 Hz | `--force-opengl` under xvfb uses CPU software rendering (llvmpipe) | Remove `--force-opengl`, let Vulkan (default) use the GPU |
| GPU at 0% utilization | OpenGL under xvfb falls back to Mesa software renderer | Use Vulkan (default) — it bypasses X11 and uses GPU directly |
| Topics not visible between containers | Mismatched `ROS_DOMAIN_ID` | All ROS2 containers must use `ROS_DOMAIN_ID=42` |
| Double namespace (`/bot/bot/topic`) | Both `namespace=veh` on Node and `PushRosNamespace(veh)` in GroupAction | Remove `namespace=` from Node declarations; let PushRosNamespace handle it |
| Node topics not connecting | ROS1-style remappings (`node_name/topic`) | Use bare topic names (`topic`) — ROS2 doesn't prefix with node name |
| `dts matrix attach` fails | Engine hostname not found | Engine auto-detects local IP; ensure robot can reach the host machine |
| Container not finding camera data | DTPS passthrough not connected to matrix | Run `dts matrix attach` after the matrix is running |
| Stacks not starting | Wrong machine hostname | Use `ROBOT_NAME.local` (with `.local` suffix) for `-H` flag |

### Complete Example: Running a DTProject on a Virtual Duckiebot

```bash
# 1. Create and start virtual robot (one time)
dts duckiebot virtual create --type duckiebot --configuration DB21J mybot
dts duckiebot virtual start mybot

# 2. Create Docker context (one time)
docker context create mybot --docker "host=tcp://mybot.local:2375"

# 3. Start platform stacks
dts stack up -H mybot.local duckietown/duckiebot -d
dts stack up -H mybot.local ros2/duckiebot -d

# 4. Start the Duckiematrix (from your DTProject directory)
cd path/to/my-dtproject
dts matrix run -S --embedded -m loop --xvfb --no-pull --no-tutorial

# 5. Attach robot to matrix (in another terminal)
dts matrix attach mybot map_0/vehicle_0

# 6. Build and run your project
dts devel build -f -H mybot
dts devel run -H mybot -L my_launcher --net host -d -- -e ROS_DOMAIN_ID=42

# 7. Verify
docker --context mybot exec dts-run-my-dtproject bash -c \
  'source /environment.sh && export ROS_DOMAIN_ID=42 && \
   ros2 topic list'
```

