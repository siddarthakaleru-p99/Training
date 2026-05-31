import logging

logging.basicConfig(
    filename='app.log', 
    filemode='a', 
    level=logging.INFO,
    format='%(levelname)s:%(name)s:%(message)s'
)
logger = logging.getLogger(__name__)

def track_shipment(func):
    def wrapper(*args, **kwargs):
        logger.info("Status: Preparing package for dispatch.")
        result = func(*args, **kwargs)
        logger.info("Status: Package handed over to carrier.")
        return result
    return wrapper

class AmazonOrder:
    def __init__(self, item_name):
        self.item_name = item_name
        logger.info(f"Order placed for: {self.item_name}")

    def __repr__(self):
        return f"AmazonOrder(Item: {self.item_name})"

    @track_shipment
    def ship_order(self, destination):
        logger.info(f"Shipping: {self.item_name} is en route to {destination}")

    def __del__(self):
        logger.info(f"Order data for {self.item_name} archived and session ended.")

prod = input("Enter the Product Name: ")
order = AmazonOrder(prod)
logger.info(f"Order Details: {order}")
addr = input("Enter the Shipping Address: ")
order.ship_order(addr)
del order