#!/usr/bin/env python3

import json
import sys
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime, timezone

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} OUTPUT_JSON", file=sys.stderr)
    sys.exit(1)

out_path = Path(sys.argv[1])

def parse_xliff(path):
    """Parse an XLIFF file and return a list of (key, value) tuples."""
    entries = []
    try:
        tree = ET.parse(path)
        root = tree.getroot()
        
        # Detect namespace
        ns = ''
        if root.tag.startswith('{'):
            ns = root.tag.split('}')[0] + '}'
        
        # Find all trans-unit elements
        trans_units = root.findall(f'.//{ns}trans-unit') if ns else root.findall('.//trans-unit')
        
        for trans_unit in trans_units:
            # Get the source text
            source_elem = trans_unit.find(f'{ns}source') if ns else trans_unit.find('source')
            if source_elem is not None:
                # Handle text content
                source_text = ''
                if source_elem.text:
                    source_text = source_elem.text.strip()
                elif len(source_elem) > 0:
                    # If source contains nested elements, get all text
                    source_text = ''.join(source_elem.itertext()).strip()
                
                # Get the id (which is often the key)
                unit_id = trans_unit.get('id', '')
                
                # Use id as key if available, otherwise use source text
                key = unit_id if unit_id else source_text
                
                if source_text and key:
                    entries.append((key, source_text))
        
        return entries
    except Exception as e:
        print(f"⚠️  Failed to parse XLIFF {path}: {e}", file=sys.stderr)
        return []

def parse_xcstrings(path):
    """Parse an .xcstrings file and return a list of (key, value) tuples."""
    entries = []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        strings = data.get("strings", {})
        source_lang = data.get("sourceLanguage", "en")
        
        print(f"📋 Parsing {path}: found {len(strings)} string entries, sourceLanguage={source_lang}", file=sys.stderr)

        for key, meta in strings.items():
            locs = meta.get("localizations", {})
            # Try the source language first; fall back to any localization.
            loc = locs.get(source_lang) or next(iter(locs.values()), {}) if locs else {}
            unit = loc.get("stringUnit", {}) if loc else {}
            value = unit.get("value") if unit else None

            if value:
                entries.append((key, value))
            else:
                # Debug: log why entry was skipped (only for first few to avoid spam)
                if len(entries) < 3:
                    if not locs:
                        print(f"   ⚠️  Skipping '{key}': no localizations found (meta keys: {list(meta.keys())})", file=sys.stderr)
                    elif not loc:
                        print(f"   ⚠️  Skipping '{key}': no localization for '{source_lang}' (available: {list(locs.keys())})", file=sys.stderr)
                    elif not unit:
                        print(f"   ⚠️  Skipping '{key}': no stringUnit found in localization", file=sys.stderr)
                    elif not value:
                        print(f"   ⚠️  Skipping '{key}': stringUnit has no value (unit keys: {list(unit.keys())})", file=sys.stderr)
        
        print(f"✅ Parsed {len(entries)} entries from {path}", file=sys.stderr)
        return entries
    except Exception as e:
        print(f"⚠️  Failed to parse {path}: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return []

# 1. Find all .xcstrings and .xliff files under the repo
root = Path(".").resolve()
xcstrings_files = list(root.rglob("*.xcstrings"))
xliff_files = list(root.rglob("*.xliff"))

# Exclude DerivedData and .git directories
xcstrings_files = [f for f in xcstrings_files if "DerivedData" not in str(f) and ".git" not in str(f)]
xliff_files = [f for f in xliff_files if "DerivedData" not in str(f) and ".git" not in str(f)]

print(f"🔍 Found {len(xcstrings_files)} .xcstrings file(s) and {len(xliff_files)} .xliff file(s)", file=sys.stderr)

# Also check for .xcloc bundles (which contain .xliff files inside)
xcloc_dirs = list(root.rglob("*.xcloc"))
for xcloc_dir in xcloc_dirs:
    if xcloc_dir.is_dir():
        # Look for .xliff files inside .xcloc bundles
        xliff_in_xcloc = list(xcloc_dir.rglob("*.xliff"))
        xliff_files.extend(xliff_in_xcloc)

if not xcstrings_files and not xliff_files:
    print("No .xcstrings or .xliff files found; skip list will be empty.", file=sys.stderr)
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

# Parse .xcstrings files
for path in xcstrings_files:
    parsed = parse_xcstrings(path)
    for key, value in parsed:
        entries.append({
            "catalogPath": str(path.relative_to(root)),
            "key": key,
            "value": value
        })

# Parse .xliff files
for path in xliff_files:
    parsed = parse_xliff(path)
    for key, value in parsed:
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

