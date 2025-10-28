#!/usr/bin/env zsh
set -euo pipefail

TMP=$(mktemp -t cliphist.XXXXXX)
trap 'rm -f "$TMP"' EXIT

# Build mapping: id<TAB>text
cliphist list | awk '{
  id=$1; $1=""; sub(/^ /,"");
  gsub(/\t/," ", $0);                 # replace any tabs in text
  print id "\t" $0
}' >"$TMP"

# Show only text in walker
selected=$(awk -F'\t' '{print $2}' "$TMP" | walker -d) || exit 1

# Find the id that matches the selected text
id=$(awk -F'\t' -v txt="$selected" '$2==txt{print $1; exit}' "$TMP")

[ -z "$id" ] && exit 1

# Decode and copy to clipboard
cliphist decode "$id" | wl-copy -n
