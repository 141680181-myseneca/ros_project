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

# Source ROS 2 environment in every shell session
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Create a workspace for the ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the entire src directory, maintaining structure
COPY src /root/dev_ws/src

# Verify package directory before proceeding
RUN ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/setup.py || { echo "ERROR: setup.py not found!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/package.xml || { echo "ERROR: package.xml not found!"; exit 1; }

# Display src path for debugging
RUN echo "Colcon will use /root/dev_ws/src"

# Fix permissions (optional)
RUN chmod -R 755 /root/dev_ws/src

# Install dependencies and build package
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && \
    echo 'Updating dependencies...' && \
    rosdep update && \
    rosdep install --from-paths /root/dev_ws/src --ignore-src -r -y && \
    echo 'Cleaning previous build files...' && \
    rm -rf build install log && \
    echo 'Building the workspace from scratch...' && \
    colcon build --symlink-install --base-paths /root/dev_ws && \
    source install/setup.bash"

# Verify build output
RUN /bin/bash -c "if [ ! -d '/root/dev_ws/install/my_robot_controller' ]; then \
      echo 'ERROR: colcon build failed, package not installed!'; \
      exit 1; \
    fi"

# Set permissions for executables
RUN chmod +x /root/dev_ws/install/my_robot_controller/bin/move_robot

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run the node
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
