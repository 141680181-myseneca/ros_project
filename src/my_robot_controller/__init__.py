import rclpy  # Import ROS 2 Python client library
import logging

# Initialize logging for the package
logging.basicConfig(level=logging.INFO)
# Advanced: File handler with rotation
file_handler = RotatingFileHandler('my_robot_controller.log', maxBytes=10240, backupCount=10)
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s : %(message)s')
file_handler.setFormatter(formatter)

# Logger setup
logger = logging.getLogger(__name__)
logger.addHandler(file_handler)
logger.setLevel(logging.INFO)

logger.info("Initializing my_robot_controller package...")
