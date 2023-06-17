from pydantic import BaseModel

class Info(BaseModel):
    id: str
    user: str
    repository: str
    issueId: int | None = None
    issueNumber: int | None = None
    title: str | None = None
    body: str | None = None
    summary: str | None = None

class StorageRequest(Info):
    pass

class StorageResponse(Info):
    pass

class ErrorResponse(BaseModel):
    message: str