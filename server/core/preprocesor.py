from typing import List, Tuple
from glob import glob
import soundfile as sf
import numpy as np
import random
import librosa

SAMPLE_RATE = 22050  # frequency with which instants of the audio signal
TARGET_SAMPLES = int(SAMPLE_RATE * 0.2)  # one second worth of audio
HOP_LENGTH = 128  # sliding window for FFT. Measured in number of samples
N_FFT = 255  # length of the windowed signal after padding with zeros


def enumerate_audio_recordings(pathname: str, shuffle=False) -> List[Tuple[int, str]]:
    recordings = glob(f"{pathname}/*/*.wav")
    if shuffle:
        random.shuffle(recordings)
    return list(enumerate(recordings))


def split_signal_into_segments(file) -> List[np.ndarray]:
    signal = read_audio_file(file)
    num_segments = (len(signal) + TARGET_SAMPLES - 1) // TARGET_SAMPLES

    segments = []

    for i in range(num_segments):
        start_sample = i * TARGET_SAMPLES
        end_sample = min((i + 1) * TARGET_SAMPLES, len(signal))
        segment = signal[start_sample:end_sample]
        segment = np.pad(segment, (0, TARGET_SAMPLES - len(segment)), "constant")
        segments.append(segment)

    return segments


def read_audio_file(file):
    signal, _ = librosa.load(file, sr=SAMPLE_RATE, dtype=np.float32)
    return signal


def save_audio_recording(filename: str, data: np.ndarray):
    sf.write(file=filename, data=data, samplerate=SAMPLE_RATE)
