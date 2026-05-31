import logging
from typing import List

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def track_shipment(func):
    def wrapper(self, *args, **kwargs):
        if not self.cart:
            logger.warning(f"Order {self.order_id} is empty. Cannot dispatch.")
            return
        logger.info("Status: Preparing package for dispatch.")
        result = func(self, *args, **kwargs)
        logger.info("Status: Package handed over to carrier.")
        return result
    return wrapper

class Product:
    def __init__(self, name: str, price: float):
        self.name = name
        self.price = price

    def __repr__(self):
        return f"Product({self.name}, ${self.price:.2f})"
        
    def __eq__(self, other):
        if isinstance(other, Product):
            return self.name == other.name and self.price == other.price
        return False

class AmazonOrder:
    def __init__(self, order_id: str):
        self.order_id = order_id
        self.cart: List[Product] = []
        logger.info(f"Order #{self.order_id} created.")

    def __repr__(self):
        return f"AmazonOrder(ID: {self.order_id}, Items: {self.cart})"

    def __str__(self):
        total = sum(item.price for item in self.cart)
        return f"Order #{self.order_id} | {len(self)} Items | Total: ${total:.2f}"

    def __add__(self, product: Product):
        if isinstance(product, Product):
            self.cart.append(product)
            logger.info(f"Added {product.name} to cart.")
            return self
        raise TypeError("Can only add Product instances to AmazonOrder.")
        
    def __sub__(self, product: Product):
        if product in self.cart:
            self.cart.remove(product)
            logger.info(f"Removed {product.name} from cart.")
        else:
            logger.warning(f"{product.name} not found in cart.")
        return self

    def __len__(self):
        return len(self.cart)

    def __bool__(self):
        return len(self.cart) > 0

    def __getitem__(self, index):
        return self.cart[index]

    def __call__(self):
        status = "Ready to ship" if self else "Empty"
        logger.info(f"Order #{self.order_id} Status: {status}")

    @track_shipment
    def ship_order(self, destination: str):
        logger.info(f"Shipping: {len(self)} item(s) en route to {destination}")

    def __del__(self):
        logger.info(f"Order data for #{self.order_id} archived and session ended.\n")

if __name__ == "__main__":
    order_id = input("Enter Order ID: ")
    order = AmazonOrder(order_id)

    while True:
        name = input("Enter product name (or 'done' to finish): ")
        if name.lower() == "done":
            break
        try:
            price = float(input("Enter product price: "))
            order += Product(name, price)
        except ValueError:
            logger.error("Invalid price. Try again.")

    remove_choice = input("Do you want to remove an item? (yes/no): ").lower()
    if remove_choice == "yes":
        name = input("Enter product name to remove: ")
        try:
            price = float(input("Enter product price: "))
            order -= Product(name, price)
        except ValueError:
            logger.error("Invalid input.")

    if order:
        logger.info(f"Cart has {len(order)} items.")
        logger.info(f"First item: {order[0]}")

    logger.info(f"Customer View: {str(order)}")
    logger.debug(f"System View: {repr(order)}")

    order()

    addr = input("Enter the Shipping Address: ")
    order.ship_order(addr)

    del order