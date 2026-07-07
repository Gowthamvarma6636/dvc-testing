from fastapi import FastAPI, UploadFile, File
from ultralytics import YOLO
import torch
import uvicorn
import io
from PIL import Image

app = FastAPI()

# Load the model on GPU
# Using the model being trained (assuming best.pt will be in runs/cumi_2/weights/best.pt)
MODEL_PATH = "/home/variphi/gowtham/model_training/runs/cumi_2/weights/best.pt"
try:
    model = YOLO(MODEL_PATH).to("cuda")
except:
    # Fallback to base model if training isn't finished
    model = YOLO("/home/variphi/gowtham/model_training/yolov8m.pt").to("cuda")

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents))
    
    # Inference
    results = model.predict(image, device=0)
    
    # Format results
    detections = []
    for r in results:
        for box in r.boxes:
            detections.append({
                "class": model.names[int(box.cls)],
                "confidence": float(box.conf),
                "bbox": box.xyxy.tolist()[0]
            })
    
    return {"detections": detections}

@app.get("/health")
async def health():
    return {"status": "ok", "gpu": torch.cuda.get_device_name(0) if torch.cuda.is_available() else "none"}

if __name__ == "__main__":
    # Use port 8085 as requested (different from default 8000)
    uvicorn.run(app, host="0.0.0.0", port=8085)
