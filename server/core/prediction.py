from typing import Any
import os

from keras.models import load_model
import numpy as np

from .utils import get_pred_percentage

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

phonemes = ["a", "e", "i", "noise", "o", "u"]
pronuns = ["correct", "incorrect", "noise"]


class PhonemeRecognitionService:
    _instance = None
    _model: Any
    _confidence_threshold = 0.7

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._model = load_model("models/phoneme_model.keras")
        return cls._instance

    def predict(self, spectrograms: np.ndarray):
        predicts = self._model.predict(spectrograms, verbose=0)
        recording = []

        for logits in predicts:
            percentage = get_pred_percentage(logits)
            predicted_class = phonemes[np.argmax(logits)]
            recording.append(
                {
                    "class": predicted_class,
                    "percentage": percentage,
                }
            )

        return recording
