import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import time
import subprocess
import os
import signal
import psutil  # ✅ Add this to monitor memory usage

class RobotMover(Node):
    def __init__(self):
        super().__init__('robot_mover')
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.timer = self.create_timer(0.5, self.move_robot)
        self.start_time = time.time()
        self.get_logger().info("RobotMover node has been started")

        # Monitor memory usage
        self.process = psutil.Process(os.getpid())

    def move_robot(self):
        # Stop after 5 seconds
        if time.time() - self.start_time > 5:
            self.get_logger().info("Shutting down after timeout...")
            self.stop()
            self.destroy_node()
            rclpy.shutdown()
        
        # ✅ Check memory usage to prevent crash
        memory_usage = self.process.memory_info().rss / (1024 * 1024)
        if memory_usage > 500:  # Adjust memory threshold (in MB)
            self.get_logger().error(f"❌ High memory usage detected ({memory_usage}MB), stopping node.")
            self.stop()
            self.destroy_node()
            rclpy.shutdown()

        msg = Twist()
        msg.linear.x = 0.5
        msg.linear.y = 0.5
        msg.angular.z = 0.1
        self.publisher_.publish(msg)
        self.get_logger().info(f"Moving robot: linear x {msg.linear.x:.2f}, y {msg.linear.y:.2f}, angular z {msg.angular.z:.2f}")

    def stop(self):
        self.get_logger().info("Stopping the robot...")
        rclpy.shutdown()

def main(args=None):
    rclpy.init(args=args)
    node = RobotMover()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        node.get_logger().info("Keyboard Interrupt received, stopping the robot.")
    finally:
        node.stop()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
