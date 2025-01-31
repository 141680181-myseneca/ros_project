# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \  
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

# Copy the entire src directory, maintaining your structure
COPY src /root/dev_ws/src

# Verify package directory structure
RUN ls -R /root/dev_ws/src/my_robot_controller

# Install missing dependencies, build the package, and ensure scripts are executable
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --symlink-install && \
    source install/setup.bash && \
    chmod +x /root/dev_ws/src/my_robot_controller/my_robot_controller/move_robot.py && \
    pip install --break-system-packages --no-deps /root/dev_ws/src/my_robot_controller && \
    ls -al /root/dev_ws/install/my_robot_controller/bin/ && \
    ls -al /root/dev_ws/install/my_robot_controller/lib/my_robot_controller/"

# Verify executables
RUN ls -al /root/dev_ws/install/my_robot_controller/bin/

# Ensure the ROS 2 environment setup file is sourced before executing any ROS 2 command
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
