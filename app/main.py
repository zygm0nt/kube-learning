from fastapi import FastAPI
import os

app = FastAPI()
@app.get("/")
def read_root():
    return {
        "message": "Hello from Kubernetes 👋",
        "version": os.getenv("APP_VERSION", "dev")
    }
