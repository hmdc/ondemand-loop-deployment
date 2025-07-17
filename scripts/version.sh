#!/bin/bash
set -e

VERSION_FILE="VERSION"
BUMP_TYPE="$1"

if [[ -z "$BUMP_TYPE" ]]; then
  echo "Usage: $0 [patch|minor|major]"
  exit 1
fi

if [[ ! -f "$VERSION_FILE" ]]; then
  echo "0.1.0+$(date +%F)" > "$VERSION_FILE"
fi

VERSION=$(cat "$VERSION_FILE")

# Extract semver and metadata
SEMVER="${VERSION%%+*}"
META="${VERSION##+}"

IFS='.' read -r MAJOR MINOR PATCH <<< "$SEMVER"

case "$BUMP_TYPE" in
  patch)
    PATCH=$((PATCH + 1))
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  *)
    echo "Unknown bump type: $BUMP_TYPE"
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}+$(date +%F)"
echo "$NEW_VERSION" > "$VERSION_FILE"
echo "Updated version: $NEW_VERSION"
