import argparse
import os
from pathlib import Path


FILE_SIZE = 256 * 1024
FILES_PER_LEAF = 6
BRANCH_DEPTHS = [6, 7, 8, 9, 7, 8, 9, 10, 6, 7, 8, 9, 7, 8, 9, 10]
NAME_PARTS = [
    "alpha beta",
    "mix,match",
    "semi;colon",
    "quote's",
    "bang!zone",
    "hash#tag",
    "plus+sign",
    "equal=value",
    "caret^up",
    "tilde~wave",
    "braces{}",
    "brackets[]",
    "paren()",
    "percent%25",
    "at@home",
    "unicode_\u00f1",
    "snow_\u2603",
    "kanji_\u4f8b",
    "greek_\u03a9",
    "math_\u2211",
]


def to_windows_long_path(path: Path) -> str:
    absolute = str(path.resolve())
    if absolute.startswith("\\\\"):
        return "\\\\?\\UNC\\" + absolute[2:]
    return "\\\\?\\" + absolute


def make_segment(branch_index: int, level: int) -> str:
    part_a = NAME_PARTS[(branch_index + level) % len(NAME_PARTS)]
    part_b = NAME_PARTS[(branch_index * 3 + level * 5) % len(NAME_PARTS)]
    filler = f"branch_{branch_index:02d}_level_{level:02d}_" + ("x" * (18 + ((branch_index + level) % 7)))
    return f"{filler}__{part_a}__{part_b}"


def write_file(path: Path, seed: int) -> None:
    payload = (f"seed={seed:04d}|".encode("utf-8") + b"Z" * 251) * 1024
    with open(to_windows_long_path(path), "wb") as handle:
        handle.write(payload[:FILE_SIZE])


def build_tree(root: Path) -> tuple[int, int, int]:
    os.makedirs(to_windows_long_path(root), exist_ok=True)

    total_dirs = 0
    total_files = 0
    longest_path = 0

    for branch_index, depth in enumerate(BRANCH_DEPTHS, start=1):
        current = root
        for level in range(1, depth + 1):
            current = current / make_segment(branch_index, level)
            os.makedirs(to_windows_long_path(current), exist_ok=True)
            total_dirs += 1
            longest_path = max(longest_path, len(str(current)))

        for file_index in range(1, FILES_PER_LEAF + 1):
            file_name = (
                f"payload_{branch_index:02d}_{file_index:02d}_"
                f"odd name unicode_\u03bb_\u4f8b_{'q' * 36}.bin"
            )
            file_path = current / file_name
            write_file(file_path, branch_index * 100 + file_index)
            total_files += 1
            longest_path = max(longest_path, len(str(file_path)))

    return total_dirs, total_files, longest_path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a Windows long-path test tree with odd names and 256 KiB files."
    )
    parser.add_argument(
        "root",
        nargs="?",
        default="long_path_output",
        help="Destination directory to create. Defaults to ./long_path_output",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    total_dirs, total_files, longest_path = build_tree(root)

    print(f"Created root: {root}")
    print(f"Directories created: {total_dirs}")
    print(f"Leaf files created: {total_files}")
    print(f"Longest path length: {longest_path}")
    print("Windows MAX_PATH exceeded:", "yes" if longest_path > 260 else "no")


if __name__ == "__main__":
    main()
