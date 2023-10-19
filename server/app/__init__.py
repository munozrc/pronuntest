from flask import Flask, request, jsonify
import pprint

from core.preprocesor import convert_audio_to_spectrograms
from core.prediction import PhonemeRecognitionService

app = Flask(__name__)
model = PhonemeRecognitionService()


@app.route("/api/", methods=["POST"])
def predict():
    recording = request.files["recording"]
    spectrograms = convert_audio_to_spectrograms(recording)

    preds = model.predict(spectrograms)
    pprint.pprint(preds)

    phonemes = list(filter(lambda pred: pred["class"] != "noise", preds))
    preds = phonemes if len(phonemes) > 0 else preds
    phoneme = max(preds, key=lambda x: x["percentage"])

    return jsonify(
        {
            "pronunciation": "correct",
            "phoneme": phoneme,
        }
    )


def init_app(config):
    app.config.from_object(config)
    return app
