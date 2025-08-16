from pydantic import BaseModel

class Message(BaseModel):
    message: str

class QuestionItem(BaseModel):
    question: str