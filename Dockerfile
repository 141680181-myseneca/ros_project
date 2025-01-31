# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release \
    build-essential \
    cmake \
    git \
    wget \
    pkg-config \
    libeigen3-dev \
    libprotobuf-dev protobuf-compiler \
    libboost-all-dev

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Create a workspace for your ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the ROS 2 package source code
COPY src/my_robot_controller /root/dev_ws/src/my_robot_controller

# Check if all necessary files are in place
RUN ls -al /root/dev_ws/src/my_robot_controller

# Install missing dependencies, build the package, and list directories for debugging
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --symlink-install && \
    source install/setup.bash && \
    echo 'Listing install directory:' && ls -al /root/dev_ws/install && \
    echo 'Listing package directory:' && ls -al /root/dev_ws/install/my_robot_controller"

# Ensure the ROS 2 environment setup file is sourced before executing any ROS 2 command
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
