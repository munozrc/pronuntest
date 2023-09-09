import preprocesor
import shutil
import os


def segment_audio_files():
    print("[*] Reading path of audio recordings...")
    recordings = preprocesor.enumerate_audio_recordings("data/raw")
    num_files = len(recordings)
    print(f"[*] Found {num_files} audio files in the raw data directory.")

    for index, pathname in recordings:
        root, filename = os.path.split(pathname)
        root = root.replace("data/raw", "data/.temp")
        name, extension = os.path.splitext(filename)
        recording = preprocesor.split_signal_into_segments(pathname)
        progress = f"{index + 1}/{num_files}"
        num_segs = len(recording)
        print(f"[*] Processing file {progress}: {filename} with {num_segs} segments...")

        if not os.path.exists(root):
            os.makedirs(root)

        for i, segment in enumerate(recording):
            new_pathname = os.path.join(root, f"{name}-{i}{extension}")
            preprocesor.save_audio_recording(new_pathname, segment)
            print(f"[+] Saved segment {i + 1}/{num_segs}: {new_pathname}")

    print("[+] Segmentation complete.")


def split_audio_dataset():
    print("\n[*] Splitting audio dataset into train and test sets...")
    recordings = preprocesor.enumerate_audio_recordings("data/.temp", True)

    test_percentage = 0.3
    num_files = len(recordings)
    num_test_files = int(num_files * test_percentage)

    print(f"[*] Total files: {num_files}")
    print(f"[*] Test files: {num_test_files}")
    print(f"[*] Train files: {num_files - num_test_files}")

    for index, pathname in recordings:
        root, filename = os.path.split(pathname)
        recording = preprocesor.read_audio_file(pathname)
        destination = "data/test" if index <= num_test_files else "data/train"
        root = root.replace("data/.temp", destination)
        pathname = os.path.join(root, filename)

        if not os.path.exists(root):
            os.makedirs(root)

        preprocesor.save_audio_recording(pathname, recording)

        if index == num_test_files:
            print("[+] Starting to move files to train set...")

    print("[+] Splitting complete.")
    shutil.rmtree("data/.temp")


if __name__ == "__main__":
    segment_audio_files()
    split_audio_dataset()
