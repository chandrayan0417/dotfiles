#!/bin/zsh
set -e

TMP_IMG="/tmp/ocr_capture.png"

# Capture region
if grim -g "$(slurp)" "$TMP_IMG"; then
    # Run OCR
    TEXT=$(tesseract "$TMP_IMG" - 2>/dev/null | sed '/^\s*$/d')

    # Remove temp image
    rm -f "$TMP_IMG"

    # Handle OCR result
    if [ -n "$TEXT" ]; then
        echo "$TEXT" | wl-copy
        notify-send "📝 OCR Complete" "Text copied to clipboard."
    else
        notify-send "⚠️ OCR Failed" "No readable text found."
    fi
else
    notify-send "❌ OCR Cancelled" "No area selected."
fi

