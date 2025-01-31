from setuptools import setup

package_name = 'my_robot_controller'

setup(
    name=package_name,
    version='0.0.1',
    packages=[package_name],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Your Name',
    maintainer_email='your-email@example.com',
    description='A simple ROS 2 robot controller.',
    license='BSD',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'move_robot = my_robot_controller.move_robot:main'
        ],
    },
)
