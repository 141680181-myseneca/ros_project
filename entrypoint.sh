#!/bin/bash
set -e

# Source the ROS environment
source /opt/ros/jazzy/setup.bash
# Source your workspace install (if built successfully)
source /root/dev_ws/install/setup.bash

# Execute the passed command (e.g., the default CMD or an override)
exec "$@"
