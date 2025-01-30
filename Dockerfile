# Use a ROS 2 base image that is compatible with Ubuntu 24.04
FROM osrf/ros:jazzy-desktop

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system utilities
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg2

# Add the OSRF Gazebo repository
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -sc` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -s http://packages.osrfoundation.org/gazebo.key | apt-key add -

# Install Gazebo Harmonic specifically
RUN apt-get update && apt-get install -y gazebo-harmonic

# Source ROS 2 environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Set up entrypoint to simply run bash to allow for interactive troubleshooting
CMD ["bash"]
