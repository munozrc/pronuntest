from typing import List, Tuple
from glob import glob
import random

import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


def enumerate_recordings(pathname: str, shuffle=False) -> List[Tuple[int, str]]:
    recordings = glob(f"{pathname}/*/*.wav")
    if shuffle:
        random.shuffle(recordings)
    return list(enumerate(recordings))


def plot_model_metrics(epoch, metrics):
    plt.figure(figsize=(10, 5))

    plt.subplot(1, 2, 1)
    plt.plot(epoch, metrics["loss"], label="Training Loss")
    plt.plot(epoch, metrics["val_loss"], label="Validation Loss")
    plt.legend()
    plt.xlabel("Epoch", fontsize=14, fontweight="bold", labelpad=10)
    plt.ylabel("Loss [CrossEntropy]", fontsize=14, fontweight="bold", labelpad=10)
    plt.title("Loss Evolution", fontsize=16, fontweight="bold")

    plt.subplot(1, 2, 2)
    plt.plot(epoch, 100 * np.array(metrics["accuracy"]), label="Training Accuracy")
    plt.plot(
        epoch, 100 * np.array(metrics["val_accuracy"]), label="Validation Accuracy"
    )
    plt.legend()
    plt.ylim(0, 100)
    plt.xlabel("Epoch", fontsize=14, fontweight="bold", labelpad=10)
    plt.ylabel("Accuracy [%]", fontsize=14, fontweight="bold", labelpad=10)
    plt.title("Accuracy Evolution", fontsize=16, fontweight="bold")

    plt.tight_layout()
    plt.show()


def plot_confusion_matrix(confusion_mtx, classes):
    plt.figure(figsize=(10, 5))
    sns.heatmap(
        confusion_mtx,
        xticklabels=classes,
        yticklabels=classes,
        annot=True,
        fmt="g",
    )
    plt.xlabel("Prediction", fontsize=14, fontweight="bold", labelpad=10)
    plt.ylabel("Expected", fontsize=14, fontweight="bold", labelpad=10)
    plt.title("Confusion Matrix", fontsize=16, fontweight="bold")
    plt.show()


def get_pred_percentage(logits: np.ndarray) -> np.float32:
    # Subtract the max logit to prevent overflow
    logits_exp = np.exp(logits - np.max(logits))
    probabilities = logits_exp / np.sum(logits_exp, axis=-1, keepdims=True)
    max_probability = np.max(probabilities, axis=-1)
    return round(max_probability * 100, 1)
