from setuptools import setup
from glob import glob
import os

package_name = 'my_robot_controller'  # Reverted to original package name

setup(
    name=package_name,
    version='0.0.1',
    packages=[package_name],  # Explicitly define package
    data_files=[
        ('share/ament_index/resource_index/packages', [os.path.join('resource', package_name)]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', glob('launch/*.launch.py')),
        ('share/' + package_name + '/config', glob('config/*.yaml')),
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
            'move_robot = my_robot_controller.move_robot:main'  # Reverted entry point
        ],
    },
)
