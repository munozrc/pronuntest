from flask import Flask, request, jsonify

from core.preprocesor import convert_audio_to_spectrograms
from core.prediction import PhonemeRecognitionService

app = Flask(__name__)
model = PhonemeRecognitionService()


@app.route("/api/", methods=["POST"])
def predict():
    recording = request.files["recording"]
    spectrograms = convert_audio_to_spectrograms(recording)
    predicted_class = model.predict(spectrograms)

    return jsonify(
        {
            "status": "succesfully",
            "phoneme": predicted_class,
            "pronunciation": "correct",
        }
    )


def init_app(config):
    app.config.from_object(config)
    return app
