import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import time
import subprocess
import os
import signal

class RobotMover(Node):
    def __init__(self):
        super().__init__('robot_mover')
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.get_logger().info("RobotMover node has been started")

        # Attempt to start a background subprocess (e.g., a sensor simulator or additional control mechanism)
        # This is an example; replace the command with something relevant to your project or remove if unnecessary
        try:
            self.process = subprocess.Popen(['your_command_here'], preexec_fn=os.setsid)
            self.get_logger().info("Subprocess started successfully.")
        except Exception as e:
            self.get_logger().error(f"Failed to start subprocess: {str(e)}")

        self.timer = self.create_timer(0.5, self.move_robot)

    def move_robot(self):
        msg = Twist()
        msg.linear.x = 0.5    # forward motion
        msg.linear.y = 0.5    # lateral motion for diagonal effect
        msg.angular.z = 0.1   # slight rotation (optional)
        self.publisher_.publish(msg)
        self.get_logger().info('Moving robot: linear x %0.2f, y %0.2f, angular z %0.2f' % (msg.linear.x, msg.linear.y, msg.angular.z))

    def stop(self):
        self.get_logger().info('Stopping the robot and any subprocess...')
        if self.process:
            os.killpg(os.getpgid(self.process.pid), signal.SIGTERM)  # Terminate the process group
            self.process.wait()  # Ensure the process resources are cleaned up
            self.process = None

def main(args=None):
    rclpy.init(args=args)
    node = RobotMover()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        node.get_logger().info("Keyboard Interrupt (Ctrl+C) received, stopping the robot.")
    finally:
        node.stop()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
