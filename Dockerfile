# Use a ROS 2 Jazzy base image based on Ubuntu 20.04 focal
FROM osrf/ros:jazzy-desktop-focal

ENV DEBIAN_FRONTEND=noninteractive

# Add the OSRF Gazebo repository (now it naturally matches focal)
RUN curl -s https://packages.osrfoundation.org/gazebo.key | apt-key add - && \
    echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable focal main" > /etc/apt/sources.list.d/gazebo-stable.list

# Install system dependencies and Gazebo (adjust Gazebo version as required)
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
    libboost-all-dev \
    gazebo11  \
    libgazebo11-dev

# Ensure the ROS environment is sourced on shell startup
RUN echo "source /opt/ros/jazzy/setup.sh" >> ~/.bashrc

# Create a ROS workspace
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the entire src directory (keeping your multi-level folder structure)
COPY src /root/dev_ws/src

# Verify that the package directory and key files exist
RUN ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/setup.py || { echo "ERROR: setup.py not found!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/package.xml || { echo "ERROR: package.xml not found!"; exit 1; }

# Display confirmation of the workspace structure
RUN echo "Colcon will use /root/dev_ws/src"

# (Optional) Fix permissions if needed
RUN chmod -R 755 /root/dev_ws/src

# Install ROS dependencies for your workspace
RUN /bin/bash -c "source /opt/ros/jazzy/setup.sh && \
    echo 'Updating dependencies...' && \
    rosdep update && \
    rosdep install --from-paths /root/dev_ws/src --ignore-src -r -y"

# Clean previous build files and build the workspace from scratch
RUN /bin/bash -c "source /opt/ros/jazzy/setup.sh && \
    echo 'Cleaning previous build files...' && \
    rm -rf build install log src/my_robot_controller.egg-info && \
    echo 'Building the workspace from scratch...' && \
    colcon build --symlink-install --base-paths /root/dev_ws/src --packages-select my_robot_controller && \
    source install/setup.sh"

# (Optional) Verify that the built executables exist
RUN ls -al /root/dev_ws/install/my_robot_controller/bin/

# Copy the entrypoint script and ensure it is executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run your node (this will later command Gazebo to simulate your robot)
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
