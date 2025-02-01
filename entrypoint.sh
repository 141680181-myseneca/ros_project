#!/bin/bash
set -e

# Source the ROS 2 Humble environment instead of Jazzy
source /opt/ros/humble/setup.bash
# Source your workspace installation
source /root/dev_ws/install/setup.bash

# Execute the passed command (default or override)
exec "$@"
