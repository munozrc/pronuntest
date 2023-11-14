from typing import Any
import os

from keras.models import load_model
import tensorflow as tf

from utils import plot_confusion_matrix
from dataset import load_dataset_file

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

model_path = "models/phoneme_model.h5"
model_phoneme: Any = load_model(model_path)

X_test, y, classes = load_dataset_file("data/test.json")
y_classes = classes["sounds"]
y_test = y["sound"]

y_pred = model_phoneme.predict(X_test)
y_pred = tf.argmax(y_pred, axis=1)

confusion_mtx = tf.math.confusion_matrix(y_test, y_pred)
plot_confusion_matrix(confusion_mtx, y_classes)
