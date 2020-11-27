import logging.config

from flask import Flask
from utils import constants
from flask_cors import CORS

app = Flask(__name__, static_folder='./frontend/build', static_url_path='')
CORS(app)

logging.basicConfig(level="DEBUG")


logging.config.fileConfig(constants.LOGGING_FILE_NAME, disable_existing_loggers=False)
logger = logging.getLogger(__name__)


@app.route('/')
def root():
    return app.send_static_file('index.html')


if __name__ == "__main__":
    logger.info("Aviatrix kickstart has been started.")
    from api import *

    app.run(host="0.0.0.0", port=5000, debug=True, use_reloader=True)
