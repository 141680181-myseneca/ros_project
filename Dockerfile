# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
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

# Add the OSRF repository for Gazebo using secure HTTPS
RUN apt-get update && apt-get install -y wget lsb-release gnupg2 \
    && sh -c 'echo "deb https://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -sc` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt-get update && apt-get install -y gazebo11

# Install ROS 2 Gazebo packages
RUN apt-get update && apt-get install -y ros-jazzy-gazebo-ros-pkgs

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Create a workspace for your ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the ROS 2 package source code
COPY ./src/my_robot_controller /root/dev_ws/src/my_robot_controller

# Install missing dependencies using rosdep
RUN . /opt/ros/jazzy/setup.bash \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && colcon build

# Set up entrypoint to start the robot controller
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash and ros2 run my_robot_controller move_robot"]
