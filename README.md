# 🚀 ROS 2 Robot Controller - Docker Container

This repository provides a **ROS 2 Jazzy-based Docker container** for running the `my_robot_controller` package, including the `move_robot` node.

## 📦 Container Information
- **Docker Image:** `tangbr/project1_ros2:latest`
- **ROS 2 Distribution:** Jazzy (Ubuntu 24.04)
- **Package:** `my_robot_controller`
- **Executable Node:** `move_robot`

---

## **📥 Pull the Docker Image**
To download the pre-built container from DockerHub, run:

```bash
docker pull tangbr/project1_ros2:latest

PROJ_ROS_GAZ/
├── src/
│   └── my_robot_controller/
│       ├── package.xml
│       ├── setup.py
│       ├── my_robot_controller/
│       │   ├── __init__.py
│       │   └── move_robot.py
│       └── resource/
│           └── my_robot_controller  (marker file)
