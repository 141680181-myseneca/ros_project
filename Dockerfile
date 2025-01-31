# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \
    python3-venv \
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

    # Verify colcon build output
    echo 'Verifying colcon build output...' && \
    if [ ! -d \"/root/dev_ws/install/my_robot_controller\" ]; then \
      echo 'ERROR: colcon build failed, package not installed!'; \
      exit 1; \
    fi && \

    chmod +x /root/dev_ws/install/my_robot_controller/bin/move_robot && \
    python3 -m pip install --break-system-packages --no-deps /root/dev_ws/src/my_robot_controller && \
    ls -al /root/dev_ws/install/my_robot_controller/bin/ && \
    ls -al /root/dev_ws/install/my_robot_controller/lib/my_robot_controller/"

# Verify executables
RUN ls -al /root/dev_ws/install/my_robot_controller/bin/

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run the node
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
