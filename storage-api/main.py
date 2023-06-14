from fastapi import FastAPI, HTTPException
from fastapi.routing import APIRoute
from fastapi.openapi.utils import generate_operation_id
from typing import Any, Callable, Set, TypeVar
from info import StorageRequest, StorageResponse, ErrorResponse

app = FastAPI(
    title="GitHub Issue Storage API",
    version="v1"
)
F = TypeVar("F", bound=Callable[..., Any])


def remove_422(func: F) -> F:
    func.__remove_422__ = True
    return func


def remove_422s(app: FastAPI) -> None:
    openapi_schema = app.openapi()
    operation_ids_to_update: Set[str] = set()
    for route in app.routes:
        if not isinstance(route, APIRoute):
            continue
        methods = route.methods or ["GET"]
        if getattr(route.endpoint, "__remove_422__", None):
            for method in methods:
                operation_ids_to_update.add(generate_operation_id(route=route, method=method))
    paths = openapi_schema["paths"]
    for path, operations in paths.items():
        for method, metadata in operations.items():
            operation_id = metadata.get("operationId")
            if operation_id in operation_ids_to_update:
                metadata["responses"].pop("422", None)

@app.post("/issues", tags=["Storage"], response_model=StorageResponse, responses={401: {"model": ErrorResponse}, 403: {"model": ErrorResponse}})
@remove_422
async def store_issue(storage_request: StorageRequest):
    # Your storage logic here
    
    #if it is not authorized, raise 401 error with "Unathorized" message
    if storage_request.user != "admin":
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    #if it is forbidden, raise 403 error with "Forbidden" message
    elif storage_request.repository == "private":
        raise HTTPException(status_code=403, detail="Forbidden")
    
    return storage_request


remove_422s(app)