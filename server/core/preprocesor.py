from typing import List
import soundfile as sf
import numpy as np
import librosa
import random

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


def get_spectrogram(signal: np.ndarray) -> np.ndarray:
    spectrogram = librosa.stft(signal, n_fft=N_FFT, hop_length=HOP_LENGTH)
    spectrogram = np.abs(spectrogram.T)
    return np.expand_dims(spectrogram, axis=2)


def add_white_noise(signal: np.ndarray, output: str):
    noise_percentage_factor = 0.2
    noise = np.random.normal(0, signal.std(), signal.size)
    augmented_signal = signal + noise * noise_percentage_factor
    save_audio(output, augmented_signal)


def add_time_stretch(signal: np.ndarray, output: str):
    augmented_signal = librosa.effects.time_stretch(signal, rate=0.3)
    save_audio(output, augmented_signal)


def add_pitch_scale(signal: np.ndarray, output: str):
    augmented_signal = librosa.effects.pitch_shift(y=signal, sr=SAMPLE_RATE, n_steps=2)
    save_audio(output, augmented_signal)


def add_random_gain(signal: np.ndarray, output: str):
    gain_rate = random.uniform(0.1, 0.12)
    augmented_signal = signal * gain_rate
    save_audio(output, augmented_signal)
