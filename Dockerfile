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

# Add the official Gazebo repository
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

# Update package lists
RUN apt update --allow-insecure-repositories

# Install Gazebo and ROS-Gazebo bridge
RUN apt install -y \
    ros-humble-gz-sim \
    gazebo11 \
    ros-humble-gazebo-ros-pkgs

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
