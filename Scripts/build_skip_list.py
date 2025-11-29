#!/usr/bin/env python3

import json
import sys
import subprocess
from pathlib import Path
from datetime import datetime, timezone

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} OUTPUT_JSON", file=sys.stderr)
    sys.exit(1)

out_path = Path(sys.argv[1])

# 1. Find all .xcstrings files under the repo
root = Path(".").resolve()
xcstrings_files = list(root.rglob("*.xcstrings"))

if not xcstrings_files:
    print("No .xcstrings files found; skip list will be empty.", file=sys.stderr)
    # Write structured output with metadata even for empty lists
    output = {
        "version": 1,
        "count": 0,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "strings": []
    }
    out_path.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")
    sys.exit(0)

entries = []

for path in xcstrings_files:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as e:
        print(f"⚠️  Failed to parse {path}: {e}", file=sys.stderr)
        continue

    strings = data.get("strings", {})
    source_lang = data.get("sourceLanguage", "en")

    for key, meta in strings.items():
        locs = meta.get("localizations", {})
        # Try the source language first; fall back to any localization.
        loc = locs.get(source_lang) or next(iter(locs.values()), {})
        unit = loc.get("stringUnit", {})
        value = unit.get("value")

        if value:
            entries.append({
                "catalogPath": str(path.relative_to(root)),
                "key": key,
                "value": value
            })

# Write structured output with metadata
output = {
    "version": 1,
    "count": len(entries),
    "timestamp": datetime.utcnow().isoformat() + "Z",
    "strings": entries
}
out_path.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"✅ Wrote skip list with {len(entries)} entries to {out_path}")

