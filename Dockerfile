# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive
# Set up the working directory
# WORKDIR /ros2_ws

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release \
    build-essential \
    cmake \
    git \
    lsb-release \
    gnupg2 \
    wget

# Add the OSRF repository manually (force Ubuntu 22.04 'jammy' instead of 'noble')
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable jammy main" > /etc/apt/sources.list.d/gazebo-stable.list \
    && curl -s http://packages.osrfoundation.org/gazebo.key | apt-key add - \
    && apt-get update \
    && apt-get install -y gazebo11

# # Install Gazebo from the OSRF repository
# RUN apt-get install -y gazebo11 || apt-get install -y gazebo9

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
# CMD ["bash", "-c", "source /ros2_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
CMD ["bash", "-c", "source /root/dev_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]