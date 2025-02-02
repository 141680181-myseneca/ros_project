# Use a ROS 2 Humble base image (Ubuntu 22.04 / jammy)
FROM ros:humble-ros-base

# Set noninteractive frontend for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set Gazebo environment variables as recommended in the tutorial
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV QT_QPA_PLATFORM=xcb

# Install curl, gnupg, and other system dependencies
RUN apt-get update && apt-get install -y curl gnupg software-properties-common

# Add the OSRF Gazebo repository for Ubuntu 22.04 (jammy)
RUN curl -s https://packages.osrfoundation.org/gazebo.key | apt-key add - && \
    echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable jammy main" > /etc/apt/sources.list.d/gazebo-stable.list

# Update and install additional system dependencies including Gazebo and ROS build tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
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
    gazebo \
    libgazebo-dev

# Create a workspace for your ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the entire src directory (preserving your folder structure)
COPY src /root/dev_ws/src

# Verify that key package files exist
RUN ls -R /root/dev_ws/src || { echo "ERROR: src directory missing!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/setup.py || { echo "ERROR: setup.py not found!"; exit 1; }
RUN test -f /root/dev_ws/src/my_robot_controller/package.xml || { echo "ERROR: package.xml not found!"; exit 1; }
RUN echo "Colcon will use /root/dev_ws/src"
RUN chmod -R 755 /root/dev_ws/src

# Build your ROS workspace:
#   • Source ROS 2 Humble
#   • Update dependencies using rosdep
#   • Clean previous build files
#   • Build with the merged install layout so that all packages are installed in a single directory
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    echo 'Updating dependencies...' && \
    rosdep update && \
    rosdep install --from-paths /root/dev_ws/src --ignore-src -r -y && \
    echo 'Cleaning previous build files...' && \
    rm -rf build install log && \
    echo 'Building the workspace from scratch...' && \
    colcon build --merge-install --base-paths /root/dev_ws/src --packages-select my_robot_controller && \
    source install/setup.bash"


# (Optional) List the installed executable to verify it is present
RUN ls -al /root/dev_ws/install/bin/

# Copy the entrypoint script and set it as executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint so that the ROS 2 and workspace environments are sourced
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run your node via ros2 run (if no command is provided)
CMD ["ros2", "run", "my_robot_controller", "move_robot"]
