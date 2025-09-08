
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
        best = {
            "agent": "openai",
            "answer": gpt_reply,
            "score": 1.0,       # dummy score for general
            "rationale": "General question – no legal scoring applied."
        }
        return {
            "intent": "general",
            "answers" : [
                {"agent": "openai", "answer": gpt_reply}
            ],
        }

    elif classification['label'] == "legal":
        openai_answer = ask_openai(item.question)
        gemini_answer = ask_gemini(item.question)

        scored_responses = []
        for agent, answer in [
            ("openai", openai_answer),
            ("gemini", gemini_answer),
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

@app.post("/classify")
async def classify(item: QuestionItem):
    print(f"📩 Incoming request: {item.question}")  # <── log every incoming query
    result = await classify_question(item)
    print(f"📤 Classification result sent back: {result}")  # <── log the response
    return result