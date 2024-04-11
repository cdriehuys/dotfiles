#!/usr/bin/env python3

import collections
import json
import os
import random
import subprocess
from pathlib import Path
from typing import Optional

WALLPAPER_DIR = Path.home() / "Pictures" / "Wallpaper"


def get_sway_outputs():
    raw_json = subprocess.check_output(
        [
            "swaymsg",
            "--socket",
            os.environ["SWAYSOCK"],
            "--type",
            "get_outputs",
            "--raw",
        ]
    )
    outputs = json.loads(raw_json)

    return outputs


def find_active_resolutions(outputs: list[dict]) -> dict:
    resolution_map = collections.defaultdict(list)
    for output in outputs:
        if output.get("active", False):
            mode = output.get("current_mode")
            if mode:
                key = f"{mode['width']}x{mode['height']}"
                resolution_map[key].append(output["name"])

    return resolution_map


def select_wallpaper(resolution: str) -> Optional[Path]:
    directory = WALLPAPER_DIR / resolution
    if not directory.is_dir():
        return None

    files = list(directory.iterdir())
    if not files:
        return None

    return random.choice(files)


def assign_wallpaper(wallpaper: Path, displays: list[str]):
    for display in displays:
        print(f"Setting {display} wallpaper to: {wallpaper}")
        subprocess.check_call(
            [
                "swaymsg",
                "--socket",
                os.environ["SWAYSOCK"],
                "output",
                display,
                "background",
                str(wallpaper),
                "fill",
            ]
        )


def main():
    outputs = get_sway_outputs()

    active_resolutions = find_active_resolutions(outputs)

    for resolution, displays in active_resolutions.items():
        wallpaper = select_wallpaper(resolution)
        print(f"Using {resolution} wallpaper: {wallpaper}")

        if wallpaper:
            assign_wallpaper(wallpaper, displays)


if __name__ == "__main__":
    main()
