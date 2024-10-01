import logging
import os

import azure.functions as func

from src.stuff_service import StuffService

app = func.FunctionApp()


@app.route(
    route="get_stuff/{stuff_id}",
    auth_level=func.AuthLevel.ANONYMOUS,
    methods=[func.HttpMethod.GET],
)
def get_stuff(req: func.HttpRequest) -> func.HttpResponse:
    stuff_id: str = req.route_params.get("stuff_id")

    logging.info("Getting stuff with id '%s'", stuff_id)
    api_key = os.environ["STUFF_API_KEY"]
    service = StuffService(api_key=api_key)
    return func.HttpResponse(service.get_thingy(thing_id=stuff_id))
