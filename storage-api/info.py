class Info:
    def __init__(self, id, user, repository, issueId, issueNumber, title, body, summary):
        self.id = id
        self.user = user
        self.repository = repository
        self.issueId = issueId
        self.issueNumber = issueNumber
        self.title = title
        self.body = body
        self.summary = summary

#Info 상속한 StorageRequest class
class StorageRequest(Info):
    def __init__(self, id, user, repository, issueId, issueNumber, title, body, summary):
        super().__init__(id, user, repository, issueId, issueNumber, title, body, summary)

class StorageResponse(Info):
    def __init__(self, id, user, repository, issueId, issueNumber, title, body, summary):
        super().__init__(id, user, repository, issueId, issueNumber, title, body, summary)

class ErrorResponse:
    def __init__(self, message):
        self.message = message