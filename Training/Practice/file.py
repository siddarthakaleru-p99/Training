import logging
logging.basicConfig(level=logging.INFO)
logger=logging.getLogger(__name__)

with open("demo.txt",'w') as f:
    f.write("Hi P99Soft")

try:
    with open("demo.txt") as f:
        logger.info(f.read())
except Exception as e:
    logger.error(e)

with open("demo.txt","a") as f:
    f.write("\nI am Siddartha")