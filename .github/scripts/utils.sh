#!/usr/bin/env bash
set_output() {
  local name="$1"
  local value="$2"
  echo "::notice title=Output::$name::${value}"
  echo "${name}<<EOF" >> "$GITHUB_OUTPUT"
  echo "$value" >> "$GITHUB_OUTPUT"
  echo "EOF" >> "$GITHUB_OUTPUT"
}
