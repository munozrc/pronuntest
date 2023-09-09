from typing import List, Tuple
from glob import glob
import random


def enumerate_recordings(pathname: str, shuffle=False) -> List[Tuple[int, str]]:
    recordings = glob(f"{pathname}/*/*.wav")
    if shuffle:
        random.shuffle(recordings)
    return list(enumerate(recordings))
