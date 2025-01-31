from setuptools import setup
import os
from glob import glob

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    packages=[package_name],  # Explicitly install the package
    data_files=[
        ('share/ament_index/resource_index/packages', ['package.xml']),
        ('share/' + package_name, ['package.xml']),
        ('lib/' + package_name, glob('my_robot_controller/*.py')),  # Ensure executables are in ROS 2 "lib" folder
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Xiao Ming Tang',
    maintainer_email='xmtang1@myseneca.ca',
    description='A simple robot controller for ROS 2.',
    license='BSD',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'move_robot = my_robot_controller.move_robot:main'  # This must match move_robot.py
        ],
    },
)
