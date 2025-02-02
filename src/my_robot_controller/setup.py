from setuptools import setup
from glob import glob
import os

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    # Explicitly list the package rather than using find_packages
    packages=[package_name],
    data_files=[
        # Install the marker file for the ament index:
        ('share/ament_index/resource_index/packages', [os.path.join('resource', package_name)]),
        # Install package.xml for ROS 2 tooling:
        ('share/' + package_name, ['package.xml']),
        # Optionally include your Python modules:
        ('lib/' + package_name, glob(os.path.join(package_name, '*.py'))),
        # Include launch and config files if they exist:
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
            'move_robot = my_robot_controller.move_robot:main'
        ],
    },
)
