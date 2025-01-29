# Use ROS 2 Jazzy as the base image
FROM osrf/ros:jazzy-desktop-full

# Set up the working directory
WORKDIR /ros2_ws

# Install system dependencies
RUN apt update && apt install -y \
    python3-colcon-common-extensions \
    gz-garden \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-gz-ros2-sim

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Copy the ROS 2 package source code
COPY ./src /ros2_ws/src

# Install missing dependencies using rosdep
RUN rosdep update && rosdep install --from-paths src --ignore-src -r -y

# Build the ROS 2 workspace
RUN colcon build

# Set up entrypoint
CMD ["bash", "-c", "source /ros2_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
