from fastapi import FastAPI, Depends, HTTPException, Response
from fastapi.responses import JSONResponse
from fastapi.openapi.utils import get_openapi
from fastapi.security.api_key import APIKeyHeader

import os

from model.models import StorageRequest, StorageResponse, ErrorResponse
from db.operate import insert_issue, delete_table

app = FastAPI(docs_url="/swagger")
api_key_auth = APIKeyHeader(name="x-webapi-key", scheme_name="api_key" ,auto_error=False, description="Please enter valid API Key")

# Uncomment this if you need to initialize the table
# @app.get("/delete")
# def delete():
#     delete_table()
#     return {"message": "Table deleted"}

# Custom HTTPException handler
@app.exception_handler(HTTPException)
async def custom_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={"message": exc.detail},
    )

def is_valid_key(api_key: str = Depends(api_key_auth)):
    # Compare api key with app config secret value.
    if api_key == os.environ['API_KEY']:
        return True
    else:
        return False

@app.post(
    "/issues",
    tags=["Storage"],
    response_model=StorageResponse,
    responses={
        401: {"model": ErrorResponse},
        403: {"model": ErrorResponse},
    },
    dependencies=[Depends(api_key_auth)],
)
async def store_issue(storage_request: StorageRequest, response: Response, api_key_valid: bool = Depends(is_valid_key)):
    if not api_key_valid:
        raise HTTPException(status_code=401, detail="No API Key provided or invalid API Key")

    insert_result = insert_issue(storage_request)
    
    if not insert_result:
        raise HTTPException(status_code=401, detail=insert_result)

    storage_response = StorageResponse(
        id=str(storage_request.id),
        user=storage_request.user,
        repository=storage_request.repository,
        issueId=storage_request.issueId,
        issueNumber=storage_request.issueNumber,
        title=storage_request.title,
        body=storage_request.body,
        summary=storage_request.summary
    )

    return storage_response


# Custom OpenAPI schema to override default 422 error
def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="GitHub Issue Storage API",
        version="v1",
        routes=app.routes,
    )

    # Remove 422 error from the schema
    def remove_422_error(schema):
        if isinstance(schema, dict):
            for key, value in list(schema.items()):
                if key == "422":
                    del schema[key]
                else:
                    remove_422_error(value)
        elif isinstance(schema, list):
            for item in schema:
                remove_422_error(item)

    remove_422_error(openapi_schema)

    if "ValidationError" in openapi_schema["components"]["schemas"]:
        del openapi_schema["components"]["schemas"]["ValidationError"]

    if "HTTPValidationError" in openapi_schema["components"]["schemas"]:
        del openapi_schema["components"]["schemas"]["HTTPValidationError"]

    app.openapi_schema = openapi_schema
    return app.openapi_schema


app.openapi = custom_openapi
