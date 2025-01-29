# Use ROS 2 Jazzy as the base image
FROM osrf/ros:jazzy-desktop-full

# Set up the working directory
WORKDIR /ros2_ws

# Install system dependencies and add Gazebo package sources
RUN apt update && apt install -y \
    software-properties-common \
    python3-colcon-common-extensions \
    curl \
    lsb-release && \
    curl -fsSL https://packages.osrfoundation.org/gazebo/gpg.key | tee /usr/share/keyrings/gazebo-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/gazebo-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list && \
    apt update

# Install Gazebo Garden
RUN apt install -y gz-garden

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
