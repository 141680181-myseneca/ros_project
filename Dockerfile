# Use ROS 2 Jazzy as the base image
FROM osrf/ros:jazzy-desktop-full

# Set up the working directory
WORKDIR /ros2_ws

# Add ROS 2 and Gazebo package repositories
RUN apt update && apt install -y software-properties-common && \
    add-apt-repository universe && \
    sudo apt-get update && \
    sudo apt-get install -y lsb-release curl && \
    sudo curl -sSL https://packages.osrfoundation.org/gazebo.key | sudo apt-key add - && \
    sudo sh -c 'echo "deb [arch=amd64] http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    apt update

# Install dependencies
RUN apt install -y \
    python3-colcon-common-extensions \
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

# Set up entrypoint
CMD ["bash", "-c", "source /ros2_ws/install/setup.bash && ros2 run my_robot_controller move_robot"]
