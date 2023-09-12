from typing import Any
import os

from keras.models import load_model
import numpy as np

from .utils import get_pred_percentage

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
phonemes = ["phoneme-a", "phoneme-e", "phoneme-i", "noise", "phoneme-o", "phoneme-u"]


class PhonemeRecognitionService:
    _instance = None
    _model: Any
    _confidence_threshold = 0.0

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
            percentage = get_pred_percentage(logits)
            predicted_class = phonemes[np.argmax(logits)]

            data = {
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

        if predicted["percentage"] >= self._confidence_threshold * 100:
            return predicted["predicted"]

        return "unknown"
