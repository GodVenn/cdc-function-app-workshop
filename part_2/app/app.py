import logging
import os

from flask import Flask

from src.stuff_service import StuffService

app = Flask(__name__)


@app.route("/get_stuff/<string:stuff_id>")
def get_stuff(stuff_id: str):
    logging.info("Getting stuff with id '%s'", stuff_id)
    api_key = os.environ["STUFF_API_KEY"]
    service = StuffService(api_key=api_key)
    return service.get_thingy(thing_id=stuff_id)


if __name__ == "__main__":
    app.run(debug=True)
