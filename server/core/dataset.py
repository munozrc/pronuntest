import shutil
import os

import pandas as pd

from utils import enumerate_recordings
import preprocesor as prep


def segment_audio_files():
    print("\n[*] Reading path of audio recordings...")
    recordings = enumerate_recordings("data/raw")
    num_files = len(recordings)
    print(f"[*] Found {num_files} audio files in the raw data directory.")

    for index, pathname in recordings:
        root, filename = os.path.split(pathname)
        root = root.replace("data/raw", "data/.temp")
        name, extension = os.path.splitext(filename)
        recording = prep.read_audio_segments(pathname)
        progress = f"{index + 1}/{num_files}"
        num_segs = len(recording)
        print(f"[*] Processing file {progress}: {filename} with {num_segs} segments...")

        if not os.path.exists(root):
            os.makedirs(root)

        for i, segment in enumerate(recording):
            new_pathname = os.path.join(root, f"{name}-{i}{extension}")
            prep.save_audio(new_pathname, segment)
            print(f"[+] Saved segment {i + 1}/{num_segs}: {new_pathname}")

    print("[+] Segmentation complete.")


def split_audio_dataset():
    print("\n[*] Splitting audio dataset into train and test sets...")
    recordings = enumerate_recordings("data/.temp", True)

    test_percentage = 0.3
    num_files = len(recordings)
    num_test_files = int(num_files * test_percentage)

    print(f"[*] Total files: {num_files}")
    print(f"[*] Test files: {num_test_files}")
    print(f"[*] Train files: {num_files - num_test_files}")

    for index, pathname in recordings:
        recording = prep.read_audio(pathname)
        root, filename = os.path.split(pathname)
        destination = "data/test" if index <= num_test_files else "data/train"
        root = root.replace("data/.temp", destination)
        pathname = os.path.join(root, filename)

        if not os.path.exists(root):
            os.makedirs(root)

        prep.save_audio(pathname, recording)

        if index == num_test_files:
            print("[+] Starting to move files to train set...")

    print("[+] Splitting complete.")
    shutil.rmtree("data/.temp")


def get_audio_metadata(pathname: str):
    root, filename = os.path.split(pathname)
    sound = os.path.basename(root).split("-")[1]
    pronun = None

    if sound not in ["noise"]:
        condition = filename.split("_")[3]
        pronun = "correct" if condition == "N" else "incorrect"

    return {
        "sound": sound,
        "pronunciation": pronun,
    }


def create_dataset_file(folder: str, output: str):
    print(f"\n[*] Reading audio recordings from folder: {folder}...")
    recordings = enumerate_recordings(folder)
    num_files = len(recordings)
    rows = []

    print(f"[*] Starting preprocessing of {num_files} audio recordings")
    for index, pathname in recordings:
        print(f"[{index}/{num_files}] Preprocessing file: {pathname}")
        metadata = get_audio_metadata(pathname)
        recording = prep.read_audio(pathname)
        metadata["spectrogram"] = prep.get_spectrogram(recording)
        rows.append(metadata)

    print("[*] Exporting dataset...")
    df = pd.DataFrame(rows)
    df.to_json(output, orient="records")

    print(f"[*] Dataset exported successfully in {output}")
    shutil.rmtree(folder)


def apply_data_augmentation():
    print("\n[*] Reading path of audio recordings...")
    recordings = enumerate_recordings("data/train")
    num_files = len(recordings)

    print(f"[*] Found {num_files} audio files in the raw data directory.")
    print("[*] Starting data augmentation of audio recordings")

    for index, pathname in recordings:
        print(f"[{index}/{num_files}] Preprocessing file: {pathname}")

        signal = prep.read_audio(pathname)
        root, filename = os.path.split(pathname)
        name, extension = os.path.splitext(filename)
        pathmame = os.path.join(root, f"{name}_@{extension}")

        if "background-noise" not in pathmame:
            prep.add_random_gain(signal, pathmame.replace("@", "gain"))

        prep.add_white_noise(signal, pathmame.replace("@", "white-noise"))
        prep.add_time_stretch(signal, pathmame.replace("@", "time-stretch"))
        prep.add_pitch_scale(signal, pathmame.replace("@", "pitch-scale"))

    print("[*] Data created successfully")


if __name__ == "__main__":
    segment_audio_files()
    split_audio_dataset()
    apply_data_augmentation()

    create_dataset_file("data/test", "data/test.json")
    create_dataset_file("data/train", "data/train.json")
