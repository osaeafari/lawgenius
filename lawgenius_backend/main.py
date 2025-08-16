# from fastapi import FastAPI, HTTPException
# from pydantic import BaseModel
# import openai
# from gemini_service import ask_gemini
# import os
# from dotenv import load_dotenv
# from openai import OpenAI

# # Load the environment variables
# load_dotenv()
# openai.api_key = os.getenv("OPENAI_API_KEY")

# # Initialize FastAPI app
# app = FastAPI()

# # Models
# class Message(BaseModel):
#     message: str

# class QuestionItem(BaseModel):
#     question: str

# # OpenAI client (new SDK)
# client = OpenAI(api_key=openai.api_key)

# # Test route
# @app.get("/ping")
# async def ping():
#     return {"message": "pong"}

# # Gemini route
# @app.post("/gemini")
# async def get_gemini_response(msg: Message):
#     reply = ask_gemini(msg.message)
#     return {"response": reply}

# # Classification route
# @app.post("/classify")
# async def classify_question(item: QuestionItem):
#     try:
#         response = client.chat.completions.create(
#             model="gpt-3.5-turbo",
#             messages=[
#                 {"role": "system", "content": "Classify the user's question strictly as either 'legal' or 'general'. Respond with only one word: 'legal' or 'general'."},
#                 {"role": "user", "content": item.question},
#             ],
#         )

#         label = response.choices[0].message.content.strip().lower()

#         if "legal" in label:
#             return {"label": "legal"}
#         elif "general" in label:
#             return {"label": "general"}
#         else:
#             raise ValueError("Invalid label received")

#     except Exception as e:
#         print(f"Error during classification: {e}")
#         raise HTTPException(status_code=500, detail="Could not classify the message")

from fastapi import FastAPI, HTTPException
from models import Message, QuestionItem
from classify import classify_question
from openai_service import ask_openai
from gemini_service import ask_gemini
from scoring_service import run_legalbert_scoring, run_flan_rationale
# from meta_service import ask_meta  # Optional

app = FastAPI()

@app.get("/ping")
async def ping():
    return {"message": "pong"}

@app.post("/query")
async def process_query(item: QuestionItem):
    classification = await classify_question(item)

    if classification['label'] == "general":
        gpt_reply = ask_openai(item.question)
        return {
            "intent": "general",
            "answers": [
                {"agent": "openai", "answer": gpt_reply}
            ]
        }

    elif classification['label'] == "legal":
        openai_answer = ask_openai(item.question)
        gemini_answer = ask_gemini(item.question)
        # meta_answer = ask_meta(item.question)  # Optional

        scored_responses = []
        for agent, answer in [
            ("openai", openai_answer),
            ("gemini", gemini_answer),
            # ("meta", meta_answer)
        ]:
            if not answer or answer.strip() == "":
                continue 
            score = run_legalbert_scoring(question=item.question, answer=answer)
            rationale = run_flan_rationale(question=item.question, answer=answer)
            scored_responses.append({
                "agent": agent,
                "answer": answer,
                "score": score,
                "rationale": rationale
            })

        best = max(scored_responses, key=lambda x: x['score'])

        return {
            "intent": "legal",
            "best": best,
            "all": scored_responses
        }