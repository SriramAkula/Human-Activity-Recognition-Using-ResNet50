import os
import numpy as np
from flask import Flask, request, render_template, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.resnet50 import preprocess_input
import pandas as pd

app = Flask(__name__)

# Load trained model
model = load_model(r'C:\Users\micro\OneDrive\Desktop\DevopsProject\best_model.h5')

# Load class labels
train_df = pd.read_csv(r'C:\Users\micro\OneDrive\Desktop\DevopsProject\Training_set.csv')
class_names = sorted(train_df['label'].unique().tolist())

# Upload folder setup
UPLOAD_FOLDER = 'static/uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    img_file = request.files['file']
    if img_file.filename == '':
        return jsonify({'error': 'Empty filename'}), 400

    # Clear old uploads
    for f in os.listdir(UPLOAD_FOLDER):
        os.remove(os.path.join(UPLOAD_FOLDER, f))

    img_path = os.path.join(UPLOAD_FOLDER, img_file.filename)
    img_file.save(img_path)

    # Preprocess image for ResNet50
    img = image.load_img(img_path, target_size=(224, 224))
    img_array = image.img_to_array(img)
    img_array = preprocess_input(img_array)
    img_array = np.expand_dims(img_array, axis=0)

    # Predict
    prediction = model.predict(img_array)
    confidence = float(np.max(prediction))
    predicted_class = class_names[np.argmax(prediction)]

    return jsonify({
        'prediction': predicted_class,
        'confidence': f"{confidence:.2f}"
    })

if __name__ == '__main__':
    app.run(debug=True)
