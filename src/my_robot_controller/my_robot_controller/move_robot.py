#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist

class RobotMover(Node):
    def __init__(self):
        super().__init__('robot_mover')
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.timer = self.create_timer(0.5, self.move_robot)
        self.get_logger().info("RobotMover node has been started")

    def move_robot(self):
        msg = Twist()
        msg.linear.x = 0.5  # Move forward
        msg.angular.z = 0.2  # Slight turn
        self.publisher_.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = RobotMover()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()
if __name__ == '__main__':
    main()
