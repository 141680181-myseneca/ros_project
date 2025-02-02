from setuptools import setup, find_packages
from glob import glob
import os

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    # Using find_packages(where='.') will automatically find your package and any subpackages.
    packages=find_packages(where='.'),
    package_dir={'': '.'},
    data_files=[
        # Install the marker file for the ament index so ROS 2 can locate your package.
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        # Install package.xml so that it is available for ROS 2 tooling.
        ('share/' + package_name, ['package.xml']),
        # Optionally include your Python modules (if desired)
        ('lib/' + package_name, glob('my_robot_controller/*.py')),
        # Include launch files (if you add any) and config files.
        ('share/' + package_name + '/launch', glob('launch/*.launch.py')),
        ('share/' + package_name + '/config', glob('config/*.yaml')),
    ],
    install_requires=['setuptools'],
    zip_safe=False,
    maintainer='Xiao Ming Tang',
    maintainer_email='xmtang1@myseneca.ca',
    description='A simple robot controller for ROS 2.',
    license='BSD',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            # This registers the executable “move_robot” so that ROS 2 will be able to find it.
            'move_robot = my_robot_controller.move_robot:main'
        ],
    },
)
