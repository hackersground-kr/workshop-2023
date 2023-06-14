from fastapi import FastAPI, Depends, HTTPException
from fastapi.openapi.utils import get_openapi
from fastapi.security.api_key import APIKeyHeader

from model.models import StorageRequest, StorageResponse, ErrorResponse
from db.operate import insert_issue, delete_table

app = FastAPI(docs_url="/swagger")
api_key_auth = APIKeyHeader(name="x-webapi-key", scheme_name="api_key" ,auto_error=False, description="Please enter valid API Key")

async def get_api_key(api_key: str = Depends(api_key_auth)):
    #Compare api key with app config secret value.
    if api_key == "secret":
        return api_key
    else:
        #Return 401 error with ErrorResponse model
        raise HTTPException(status_code=401, detail=ErrorResponse(message="Unauthorized"))
    
# @app.get("/delete")
# async def delete_table():
#     delete_table()
#     return "Table deleted"

@app.post("/issues", tags=["Storage"], response_model=StorageResponse, responses={401: {"model": ErrorResponse}, 403: {"model": ErrorResponse}}, dependencies=[Depends(api_key_auth)])
async def store_issue(storage_request: StorageRequest):
    get_api_key(api_key=api_key_auth)
    
    #if it is forbidden, raise 403 error with "Forbidden" message
    if storage_request.repository == "private":
        raise HTTPException(status_code=403, detail="Forbidden")
    
    #Insert issue to the database
    insert_issue(storage_request)
    
    return storage_request

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