#!/bin/bash
# Validates Maestro flow YAML files for structural correctness
set -e

ERRORS=0
TOTAL=0

echo "Validating Maestro flows..."
echo ""

for f in flows/**/*.yaml; do
  TOTAL=$((TOTAL + 1))
  flow_name=$(echo "$f" | sed 's|flows/||; s|\.yaml||')

  # Check YAML syntax (handles multi-document YAML with ---)
  if ! python3 -c "
import yaml, sys
with open('$f') as fh:
    docs = list(yaml.safe_load_all(fh))
if not docs:
    print('ERROR: Empty file')
    sys.exit(1)

# First doc should be frontmatter with appId
frontmatter = docs[0]
if isinstance(frontmatter, dict) and 'appId' in frontmatter:
    steps = docs[1] if len(docs) > 1 else []
    if not isinstance(steps, list):
        print('ERROR: Steps must be a list')
        sys.exit(1)
    step_count = len(steps) if steps else 0
    tags = frontmatter.get('tags', [])
    print(f'OK:{step_count}:{len(tags)}')
elif isinstance(frontmatter, list):
    # No frontmatter, just steps
    print(f'OK:{len(frontmatter)}:0')
else:
    print('WARN: No appId in frontmatter')
    sys.exit(0)
" 2>/dev/null; then
    echo "❌ $flow_name: Invalid YAML"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  result=$(python3 -c "
import yaml
with open('$f') as fh:
    docs = list(yaml.safe_load_all(fh))
fm = docs[0]
if isinstance(fm, dict) and 'appId' in fm:
    steps = docs[1] if len(docs) > 1 else []
    count = len(steps) if isinstance(steps, list) else 0
    tags = fm.get('tags', [])
    print(f'{count}:{len(tags)}')
elif isinstance(fm, list):
    print(f'{len(fm)}:0')
else:
    print('0:0')
" 2>/dev/null)

  steps=$(echo "$result" | cut -d: -f1)
  tags=$(echo "$result" | cut -d: -f2)

  if [ "$steps" -eq 0 ]; then
    echo "⚠️  $flow_name: 0 steps"
  else
    echo "✅ $flow_name — $steps steps, $tags tags"
  fi
done

echo ""
echo "Validated $TOTAL flows, $ERRORS errors"

if [ $ERRORS -gt 0 ]; then
  exit 1
fi

echo "All flows valid!"
