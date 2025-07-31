import openai
from dotenv import load_dotenv
import os


load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

def classify_intent(user_question: str) -> str:
    prompt = [
        {
            "role": "system",
            "content": (
                "You are an assistant that classifies user questions into two categories: "
                "LEGAL_GH (if the question relates to Ghanaian law, rights, or legal processes) "
                "or GENERAL (if it is not related to law). Only respond with LEGAL_GH or GENERAL."
            )
        },
        {
            "role": "user",
            "content": user_question
        }
    ]
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=prompt,
            temperature=0
        )
        classification = response['choices'][0]['message']['content'].strip().upper()
        if classification in ["LEGAL_GH", "GENERAL"]:
            return classification
        else:
            return "UNKNOWN"
    except Exception as e:
        print(f"Error classifying intent: {e}")
        return "ERROR"