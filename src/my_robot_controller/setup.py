from setuptools import setup, find_packages

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(exclude=['tests', 'docs']),
    install_requires=[
        'setuptools',
        'rclpy',  # Required for ROS 2 Python nodes
        'gazebo_msgs',  # If using Gazebo messages
        'geometry_msgs'  # If using robot motion commands
    ],
    zip_safe=True,
    maintainer='your_name',
    maintainer_email='your_email@example.com',
    description='A simple ROS 2 package to control a robot in Gazebo',
    license='Apache License 2.0',
    entry_points={
        'console_scripts': [
            'move_robot = my_robot_controller.move_robot:main',
        ],
    },
)
