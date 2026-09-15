#!/usr/bin/env python3
"""Check Docker Hub for new Redis minor versions and update build_redis.yml's matrix."""

import json
import re
import sys
import urllib.request
from pathlib import Path

WORKFLOW_FILE = Path(__file__).resolve().parent.parent / "workflows" / "build_redis.yml"
TAGS_URL = "https://hub.docker.com/v2/repositories/library/redis/tags?page_size=100"
VERSION_LINE_RE = re.compile(r'(version:\s*\[)([^\]]*)(\])')
MINOR_TAG_RE = re.compile(r'^(\d+)\.(\d+)-alpine$')


def fetch_available_minor_versions():
    versions = set()
    url = TAGS_URL
    while url:
        with urllib.request.urlopen(url) as response:
            payload = json.load(response)
        for result in payload.get("results", []):
            match = MINOR_TAG_RE.match(result["name"])
            if match:
                versions.add((int(match.group(1)), int(match.group(2))))
        url = payload.get("next")
    return versions


def main():
    content = WORKFLOW_FILE.read_text()
    match = VERSION_LINE_RE.search(content)
    if not match:
        print("Could not find the redis matrix version line", file=sys.stderr)
        sys.exit(1)

    current_versions = [
        tuple(int(part) for part in v.strip().strip('"').split("."))
        for v in match.group(2).split(",")
        if v.strip()
    ]
    minimum_version = min(current_versions)

    available_versions = fetch_available_minor_versions()
    new_versions = {
        v for v in available_versions
        if v >= minimum_version and v not in current_versions
    }

    if not new_versions:
        print("No new Redis versions found")
        return

    merged_versions = sorted(set(current_versions) | new_versions)
    rendered = ", ".join(f'"{major}.{minor}"' for major, minor in merged_versions)
    updated_content = content[: match.start()] + f"version: [{rendered}]" + content[match.end():]
    WORKFLOW_FILE.write_text(updated_content)

    added = ", ".join(f"{major}.{minor}" for major, minor in sorted(new_versions))
    print(f"Added Redis version(s): {added}")

    github_output = sys.argv[1] if len(sys.argv) > 1 else None
    if github_output:
        with open(github_output, "a") as fh:
            fh.write(f"added_versions={added}\n")


if __name__ == "__main__":
    main()
