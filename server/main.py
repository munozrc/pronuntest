from config import config
from app import init_app
import os

is_dev_mode = os.environ.get("MODE") == None
configuration = config["development" if is_dev_mode else "production"]
app = init_app(configuration)

if __name__ == "__main__":
    app.run()
