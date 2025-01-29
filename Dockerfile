# Use ROS 2 Jazzy as the base image
FROM osrf/ros:jazzy-desktop-full

# Set up the working directory
WORKDIR /ros2_ws

# Install system dependencies
RUN apt update && apt install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release \
    gnupg2 \
    wget

# Add the Gazebo repository for ROS packages
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    curl -s https://packages.osrfoundation.org/gazebo.key | apt-key add -

# Update package lists and install Gazebo compatible with Jazzy
RUN apt update && apt install -y \
    gazebo11 \
    ros-jazzy-gazebo-ros-pkgs

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Copy the ROS 2 package source code
COPY ./src /ros2_ws/src

# Install missing dependencies using rosdep
RUN rosdep update && rosdep install --from-paths src --ignore-src -r -y

# Build the ROS 2 workspace
RUN colcon build

# Set up entrypoint to start the robot controller
CMD ["bash", "-c", "source /ros2_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
