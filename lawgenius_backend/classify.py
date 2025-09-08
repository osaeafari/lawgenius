import os
from openai import OpenAI
from dotenv import load_dotenv
from fastapi import HTTPException
from models import QuestionItem

load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

async def classify_question(item: QuestionItem):
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "Classify the user's question strictly as either 'legal' or 'general'. Respond with only one word: 'legal' or 'general'.",
                },
                {"role": "user", "content": item.question},
            ],
        )

        raw_label = response.choices[0].message.content.strip().lower()
        print(f"🔍 Raw GPT classification output: {raw_label}")  # <── log raw response

        # Normalize label if GPT adds extra words
        if "legal" in raw_label:
            label = "legal"
        elif "general" in raw_label:
            label = "general"
        else:
            label = "general"  # default fallback

        print(f"✅ Normalized label: {label}")  # <── log final label

        return {"label": label}

    except Exception as e:
        print(f"❌ Classification error: {str(e)}")  # <── log error
        raise HTTPException(status_code=500, detail=f"Could not classify the message: {str(e)}")