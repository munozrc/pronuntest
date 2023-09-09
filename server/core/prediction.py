from typing import Any
import os

from keras.models import load_model
import numpy as np

from preprocesor import convert_audio_to_spectrograms
from utils import get_pred_percentage

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
phonemes = ["a", "e", "noise", "o"]


class PhonemeRecognitionService:
    _instance = None
    _model: Any

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._model = load_model("models/phoneme_model.keras")
        return cls._instance

    def predict(self, spectrograms: np.ndarray) -> str:
        predicts = self._model.predict(spectrograms, verbose=0)
        recording = []
        print("\n")

        for logits in predicts:
            max_confidence = np.max(logits)
            predicted_class = phonemes[np.argmax(logits)]
            percentage = get_pred_percentage(logits)

            data = {
                "max_confidence": max_confidence,
                "predicted": predicted_class,
                "percentage": percentage,
            }

            recording.append(data)
            print(data)

        print("\n")
        segs_filter = [seg for seg in recording if seg["predicted"] != "noise"]

        if not segs_filter:
            segs_filter = recording

        predicted = max(segs_filter, key=lambda x: x["percentage"])
        predicted_class = predicted["predicted"]
        return predicted_class


if __name__ == "__main__":
    model = PhonemeRecognitionService()
    recording = "data/validation/phoneme-a_correct.wav"
    spectrograms = convert_audio_to_spectrograms(recording)
    model.predict(spectrograms)
