# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release \
    build-essential \
    cmake \
    git \
    gnupg2 \
    wget

# Add the Gazebo OSRF repository
RUN curl -s http://packages.osrfoundation.org/gazebo.key | apt-key add - \
    && sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gazebo-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -sc` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && apt-get update \
    && apt-get install -y gazebo11

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Prepare the ROS 2 workspace
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the ROS 2 package source code
COPY ./src ./src

# Resolve dependencies and build the ROS 2 package
RUN . /opt/ros/jazzy/setup.bash \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && colcon build

# Set up the entrypoint to start the robot controller
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
