# Use a ROS 2 Humble base image (Ubuntu 22.04 / jammy)
FROM ros:humble-ros-base

ENV DEBIAN_FRONTEND=noninteractive

# Install curl and gnupg (if not already installed)
RUN apt-get update && apt-get install -y curl gnupg

# Add the OSRF Gazebo repository for Ubuntu 22.04 (jammy)
RUN curl -s https://packages.osrfoundation.org/gazebo.key | apt-key add - && \
    echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable jammy main" > /etc/apt/sources.list.d/gazebo-stable.list

# Update and install system dependencies including Gazebo 11 packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \
    python3-venv \
    python3-colcon-common-extensions \
    lsb-release \
    build-essential \
    cmake \
    git \
    wget \
    pkg-config \
    libeigen3-dev \
    libprotobuf-dev protobuf-compiler \
    libboost-all-dev \
    gazebo11 \
    libgazebo11-dev

# (The rest of your Dockerfile remains the same, e.g., creating a workspace, copying source code, building, etc.)
# For example:

# Create a workspace for your ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the entire src directory
COPY src /root/dev_ws/src

# Verify package files exist
RUN ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/setup.py || { echo "ERROR: setup.py not found!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/package.xml || { echo "ERROR: package.xml not found!"; exit 1; }
RUN echo "Colcon will use /root/dev_ws/src"
RUN chmod -R 755 /root/dev_ws/src

# Build the workspace with colcon
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    echo 'Updating dependencies...' && \
    rosdep update && \
    rosdep install --from-paths /root/dev_ws/src --ignore-src -r -y && \
    echo 'Cleaning previous build files...' && \
    rm -rf build install log src/my_robot_controller.egg-info && \
    echo 'Building the workspace from scratch...' && \
    colcon build --symlink-install --base-paths /root/dev_ws/src --packages-select my_robot_controller && \
    source install/setup.bash"

# (Optional) Verify installed executables
RUN ls -al /root/dev_ws/install/my_robot_controller/bin/

# Copy the entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run your node
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
