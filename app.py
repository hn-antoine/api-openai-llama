from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

app = FastAPI()

# Load the model and tokenizer
model_name = "EleutherAI/gpt-neo-2.7B"  # Adjust if using a different model
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)
model.eval()

# Define the request schema
class ChatRequest(BaseModel):
    prompt: str
    max_length: int = 50

# Define the chat endpoint
@app.post("/chat")
async def chat(request: ChatRequest):
    inputs = tokenizer(request.prompt, return_tensors="pt")
    with torch.no_grad():
        outputs = model.generate(inputs["input_ids"], max_length=request.max_length, do_sample=True)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"response": response}

