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

# Verify package directory before proceeding
RUN ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/setup.py || { echo "ERROR: setup.py not found!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/package.xml || { echo "ERROR: package.xml not found!"; exit 1; }

# Display src path to ensure correctness
RUN echo "Colcon will use /root/dev_ws/src"

# Fix permissions (optional)
RUN chmod -R 755 /root/dev_ws/src

# Clean and Rebuild the ROS 2 Package
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && \
    echo 'Cleaning previous build files...' && \
    rm -rf build install log && \
    echo 'Building the workspace from scratch...' && \
    colcon build --symlink-install --packages-select my_robot_controller && \
    source install/setup.bash"

# Build and install the ROS 2 package
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; } && \
    colcon build --symlink-install --packages-select my_robot_controller && \  
    source install/setup.bash && \
    echo 'Verifying colcon build output...' && \
    if [ ! -d '/root/dev_ws/install/my_robot_controller' ]; then \
      echo 'ERROR: colcon build failed, package not installed!'; \
      exit 1; \
    fi && \
    chmod +x /root/dev_ws/install/my_robot_controller/bin/move_robot && \
    python3 -m pip install --break-system-packages --no-deps /root/dev_ws/src/my_robot_controller && \
    ls -al /root/dev_ws/install/my_robot_controller/bin/"

# Verify executables
RUN ls -al /root/dev_ws/install/my_robot_controller/bin/

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run the node
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
