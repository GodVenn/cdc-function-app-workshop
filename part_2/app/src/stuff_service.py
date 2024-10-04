import logging


class StuffService:

    def __init__(self, api_key: str):
        self._api_key = api_key

    def get_thingy(self, thing_id: str) -> str:
        logging.info("Getting thing with id '%s'", thing_id)
        ######
        #  Calls external service with API key
        ######
        return f"spoon #{thing_id}"
