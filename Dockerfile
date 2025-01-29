# Use a ROS 2 base image that is suitable and compatible with your requirements
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools and libraries
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

# Add the OSRF repository for Gazebo
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.osrfoundation.org/gazebo.key | gpg --dearmor -o /etc/apt/keyrings/gazebo-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/gazebo-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list

# Update and install Gazebo (specify a version known to be available)
RUN apt-get update && apt-get install -y gazebo11 || true  # Or another known working version

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Prepare ROS 2 workspace
RUN mkdir -p /root/dev_ws/src
WORKDIR /root/dev_ws

# Copy the ROS 2 package source code
COPY ./src ./src

# Install dependencies and build the workspace
RUN . /opt/ros/jazzy/setup.bash && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build

# Setup entrypoint
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
