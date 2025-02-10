#!/bin/bash
set -e

# Ensure ROS 2 Humble is installed and sourced
if [ -f "/opt/ros/humble/setup.bash" ]; then
    source /opt/ros/humble/setup.bash
else
    echo "❌ ERROR: ROS 2 Humble setup.bash not found!"
    exit 1
fi

# Ensure the workspace setup file exists before sourcing
if [ -f "/root/dev_ws/install/setup.bash" ]; then
    source /root/dev_ws/install/setup.bash
else
    echo "❌ ERROR: Workspace setup.bash not found! Colcon build may have failed."
    exit 1
fi

# Execute the passed command (default or override)      
exec "$@"
