from pydantic import BaseModel

class Info(BaseModel):
    id: int
    user: str
    repository: str
    issueId: int
    issueNumber: int
    title: str
    body: str
    summary: str

class StorageRequest(Info):
    pass

class StorageResponse(Info):
    pass

class ErrorResponse(BaseModel):
    message: str
