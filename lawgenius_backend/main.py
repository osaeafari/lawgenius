from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import openai
import os
from dotenv import load_dotenv

# Load the environment variables
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

# Initialize FastAPI app
app = FastAPI()

# Define the request model BEFORE using it
class QuestionItem(BaseModel):
    question: str

# Define your classification route
@app.post("/classify")
async def classify_question(item: QuestionItem):
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Classify the question as 'legal' or 'general'"},
                {"role": "user", "content": item.question},
            ],
        )

        label = response["choices"][0]["message"]["content"].strip().lower()
        if label not in ["legal", "general"]:
            raise ValueError("Invalid label received")

        return {"label": label}

    except Exception as e:
        print(f"Error during classification: {e}")
        raise HTTPException(status_code=500, detail="Could not classify the message")