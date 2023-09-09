from typing import List
import soundfile as sf
import numpy as np
import librosa

SAMPLE_RATE = 22050  # frequency with which instants of the audio signal
TARGET_SAMPLES = int(SAMPLE_RATE * 0.2)  # one second worth of audio
HOP_LENGTH = 128  # sliding window for FFT. Measured in number of samples
N_FFT = 255  # length of the windowed signal after padding with zeros


def read_audio_segments(file) -> List[np.ndarray]:
    signal = read_audio(file)
    num_segments = (len(signal) + TARGET_SAMPLES - 1) // TARGET_SAMPLES

    segments = []

    for i in range(num_segments):
        start_sample = i * TARGET_SAMPLES
        end_sample = min((i + 1) * TARGET_SAMPLES, len(signal))
        segment = signal[start_sample:end_sample]
        segment = np.pad(segment, (0, TARGET_SAMPLES - len(segment)), "constant")
        segments.append(segment)

    return segments


def read_audio(file) -> np.ndarray:
    signal, _ = librosa.load(file, sr=SAMPLE_RATE, dtype=np.float32)
    return signal


def save_audio(filename: str, data: np.ndarray) -> None:
    sf.write(file=filename, data=data, samplerate=SAMPLE_RATE)
