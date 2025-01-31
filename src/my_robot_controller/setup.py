from setuptools import setup, find_packages
import os
from glob import glob

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(),  # Finds all submodules automatically
    package_dir={'': 'src'},  # Ensure correct package structure
    data_files=[
        ('share/ament_index/resource_index/packages', ['package.xml']),
        ('share/' + package_name, ['package.xml']),
        ('lib/' + package_name, glob('my_robot_controller/*.py')),  # Install scripts in ROS 2 expected path
        ('lib/' + package_name, glob('launch/*.launch.py')),  # Ensure launch files are installed if any
        ('share/' + package_name + '/config', glob('config/*.yaml')),  # Ensure config files are included
    ],
    install_requires=['setuptools'],
    zip_safe=False,  # Ensure extracted files for ROS 2 execution
    maintainer='Xiao Ming Tang',
    maintainer_email='xmtang1@myseneca.ca',
    description='A simple robot controller for ROS 2.',
    license='BSD',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'move_robot = my_robot_controller.move_robot:main'  # Ensure script is properly registered
        ],
    },
)
