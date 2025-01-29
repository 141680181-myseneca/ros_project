from setuptools import setup

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.1.1',  # update the version if significant changes have been made
    packages=[package_name],
    install_requires=[
        'setuptools',
        'rclpy'
    ],
    entry_points={
        'console_scripts': [
            'move_robot = my_robot_controller.move_robot:main'
        ],
    },
)
