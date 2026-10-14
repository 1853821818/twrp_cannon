#!/bin/bash
# Convert dependencies file to local_manifests for repo sync

DEPS_FILE="$1"
MANIFEST_DIR=".repo/local_manifests"

if [ -z "$DEPS_FILE" ] || [ ! -f "$DEPS_FILE" ]; then
    echo "Usage: $0 <dependencies_file>"
    exit 1
fi

mkdir -p "$MANIFEST_DIR"

python3 - "$DEPS_FILE" "$MANIFEST_DIR" << 'PYEOF'
import json, sys, os

deps_file = sys.argv[1]
manifest_dir = sys.argv[2]

with open(deps_file) as f:
    deps = json.load(f)

xml = '<?xml version="1.0" encoding="UTF-8"?>\n<manifest>\n'
for dep in deps:
    repo = dep.get('repository', '')
    target = dep.get('target_path', '')
    branch = dep.get('branch', 'master')
    remote = dep.get('remote', 'github')
    
    if not repo or not target:
        continue
    
    # Extract owner and name from repository
    parts = repo.split('/')
    if len(parts) >= 2:
        name = '/'.join(parts[-2:])
    else:
        name = repo
    
    xml += f'  <project name="{name}" path="{target}" revision="{branch}" />\n'

xml += '</manifest>\n'

out_path = os.path.join(manifest_dir, 'dependencies.xml')
with open(out_path, 'w') as f:
    f.write(xml)

print(f"Generated {out_path}")
PYEOF
