from setuptools import setup, find_packages
from glob import glob
import os

package_name = 'my_robot_controller'
current_dir = os.path.dirname(os.path.abspath(__file__))

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(where='.'),
    package_dir={'': '.'},  # Packages are in the current folder
    data_files=[
        # Install an empty marker file for ament.
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('lib/' + package_name, glob('my_robot_controller/*.py')),
        ('share/' + package_name, glob('launch/*.launch.py')),
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
            'move_robot = my_robot_controller.move_robot:main'
        ],
    },
)
