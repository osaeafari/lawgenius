# import os
# from dotenv import load_dotenv
# import google.generativeai as genai

# # Load environment variables
# load_dotenv()
# genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# for m in genai.list_models():
#     print(m.name, "->", m.supported_generation_methods)

# # Validate API key presence
# GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
# if not GEMINI_API_KEY:
#     raise ValueError("Missing GEMINI_API_KEY in .env")

# # Configure Gemini API
# genai.configure(api_key=GEMINI_API_KEY)

# # Initialize model once
# model = genai.GenerativeModel(model_name="gemini-1.5-flash")

# def ask_gemini(prompt: str) -> str:
#     try:
#         response = model.generate_content(prompt)
        
#         # Defensive check: response should have text
#         if hasattr(response, 'text') and response.text.strip():
#             return response.text.strip()
#         else:
#             print("Gemini response was empty or malformed.")
#             return ""
    
#     except Exception as e:
#         print(f"[Gemini API Error]: {e}")
#         return ""
    
# if __name__ == "__main__":
#     print(ask_gemini("What is the Constitution?"))

import os
from dotenv import load_dotenv
import google.generativeai as genai

# Load environment variables
load_dotenv()
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("Missing GEMINI_API_KEY in .env")

# Configure API
genai.configure(api_key=api_key)

# Use a valid model
model = genai.GenerativeModel("gemini-1.5-pro-latest")

def ask_gemini(prompt: str) -> str:
    try:
        response = model.generate_content(prompt)
        return response.candidates[0].content.parts[0].text.strip()
    except Exception as e:
        print(f"[Gemini API Error]: {e}")
        return "[Gemini error or no response]"
    
if __name__ == "__main__":
    print("Gemini says:")
    print(ask_gemini("What is the Constitution of Ghana?"))