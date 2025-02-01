#!/bin/bash
set -e

# Source the ROS 2 Humble environment instead of jazzy
source /opt/ros/humble/setup.bash
# Source your workspace installation (if built successfully)
source /root/dev_ws/install/setup.bash

# Execute the passed command (e.g., the default CMD)
exec "$@"

