function uploadImage() {
  const input = document.getElementById('imageInput');
  const file = input.files[0];
  const resultDiv = document.getElementById('result');
  const previewDiv = document.getElementById('preview');

  resultDiv.innerHTML = ''; // Clear previous result
  previewDiv.innerHTML = ''; // Clear previous image

  if (file) {
    const formData = new FormData();
    formData.append('file', file);

    const reader = new FileReader();
    reader.onload = function (e) {
      const img = document.createElement('img');
      img.src = e.target.result;
      img.style.maxWidth = '300px';
      previewDiv.appendChild(img);
    };
    reader.readAsDataURL(file);

    fetch('/predict', {
      method: 'POST',
      body: formData,
    })
    .then(response => response.json())
    .then(data => {
      resultDiv.innerHTML = `<p><strong>Prediction:</strong> ${data.prediction}<br><strong>Confidence:</strong> ${data.confidence}</p>`;
    })
    .catch(error => {
      resultDiv.innerHTML = '<p>Error during prediction.</p>';
      console.error('Error:', error);
    });
  }
}
