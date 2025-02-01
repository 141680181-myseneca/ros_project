from setuptools import setup, find_packages
import os
from glob import glob

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(where="src"),  # Ensures package discovery inside 'src/'
    package_dir={'': 'src'},  # Ensures correct package structure
    options={
        'build': {'build_base': 'build'},
        'install': {'egg_base': os.path.abspath("src")}  # 👈 Ensure egg_base points to src/
    },    
    data_files=[
        ('share/ament_index/resource_index/packages', ['package.xml']),
        ('share/' + package_name, ['package.xml']),
        ('lib/' + package_name, glob('src/my_robot_controller/my_robot_controller/*.py')),  # Fix package detection
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
