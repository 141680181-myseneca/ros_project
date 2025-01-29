# Use ROS 2 Jazzy base image with Gazebo
FROM osrf/ros:jazzy-desktop-full

# Set up the working directory
WORKDIR /ros2_ws

# Install dependencies
RUN apt update && apt install -y \
    python3-colcon-common-extensions \
    gazebo ros-jazzy-gazebo-ros-pkgs

# Copy the source files
COPY ./src /ros2_ws/src

# Build the ROS 2 workspace
RUN colcon build && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Set up entrypoint
CMD ["bash", "-c", "source /ros2_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
