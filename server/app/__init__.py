from flask import Flask, request, jsonify
import pprint

from core.preprocesor import convert_audio_to_spectrograms
from core.prediction import PhonemeRecognitionService

app = Flask(__name__)
model = PhonemeRecognitionService()


@app.route("/api/", methods=["POST"])
def most_frequent_phoneme():
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


@app.route("/api/word/<pattern>", methods=["POST"])
def validate_phoneme_pattern(pattern: str):
    recording = request.files["recording"]
    spectrograms = convert_audio_to_spectrograms(recording)
    predictions = model.predict(spectrograms)

    pprint.pprint(predictions)

    phoneme = None
    percentage = 0.0
    phonemes = []

    for prediction in predictions:
        if prediction["class"] == phoneme:
            if prediction["percentage"] > percentage:
                percentage = prediction["percentage"]
                phonemes[-1]["percentage"] = prediction["percentage"]
            continue

        phoneme = prediction["class"]
        percentage = prediction["percentage"]
        phonemes.append(prediction)

    start_pattern = None
    phonemes = list(filter(lambda pred: pred["class"] != "noise", phonemes))

    pprint.pprint(phonemes)

    for i, phoneme in enumerate(phonemes):
        if phoneme["class"] == pattern[0]:
            start_pattern = i
            break

    if start_pattern == None:
        return jsonify({"word": pattern, "score": 0, "phonemes": []})

    default_phoneme = {"class": "unknown", "percentage": 0.0}
    predicted = phonemes[start_pattern : start_pattern + len(pattern)]
    predicted = predicted + [default_phoneme] * (len(pattern) - len(predicted))

    total_percentage = sum(phoneme["percentage"] for phoneme in predicted)
    average = total_percentage / len(predicted) if len(predicted) > 0 else 0

    return jsonify({"word": pattern, "score": average, "phonemes": predicted})


def init_app(config):
    app.config.from_object(config)
    return app
