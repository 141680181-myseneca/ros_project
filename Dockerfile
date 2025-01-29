# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies required for Gazebo and ROS 2
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release \
    build-essential \
    cmake \
    git \
    gnupg2 \
    wget \
    pkg-config \
    libeigen3-dev \
    libprotobuf-dev protobuf-compiler \
    libboost-all-dev

# Add the OSRF repository for Gazebo (Fixed for Ubuntu 24.04)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL http://packages.osrfoundation.org/gazebo/gazebo-archive-keyring.gpg | tee /etc/apt/keyrings/gazebo-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/gazebo-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && apt-get install -y gazebo11

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Create a workspace for your ROS 2 package
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the ROS 2 package source code
COPY ./src ./src

# Install missing dependencies using rosdep
RUN . /opt/ros/jazzy/setup.bash \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && colcon build

# Set up entrypoint to start the robot controller
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
