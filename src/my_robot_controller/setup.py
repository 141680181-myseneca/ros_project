from setuptools import setup, find_packages
import os
from glob import glob

package_name = 'my_robot_controller'
current_dir = os.path.dirname(os.path.abspath(__file__))  # Get absolute path of setup.py

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(where='.'),  # Ensure package discovery in current directory
    package_dir={'': '.'},  # Avoid using 'src', which causes build issues
    options={
        'build': {'build_base': 'build'},
        'install': {'egg_base': current_dir}  # Ensure egg_base is correctly set
    },    
    data_files=[
        ('share/ament_index/resource_index/packages', ['package.xml']),
        ('share/' + package_name, ['package.xml']),
        ('lib/' + package_name, glob('my_robot_controller/*.py')),  # Fix package detection
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
