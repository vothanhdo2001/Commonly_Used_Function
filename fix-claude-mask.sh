#!/usr/bin/env bash
# Linux / macOS:  bash fix-claude-mask.sh
# Sau khi chay -> Ctrl+Shift+P -> "Developer: Reload Window".
CSS='[class*="toolBodyRowContent_"]:not([class*="disableClipping"]){-webkit-mask-image:linear-gradient(to bottom,#000 50px,transparent 60px)!important;mask-image:linear-gradient(to bottom,#000 50px,transparent 60px)!important}/*custom-bg-fix*/'
for f in \
  "$HOME"/.vscode/extensions/anthropic.claude-code-*/webview/index.css \
  "$HOME"/.vscode-server/extensions/anthropic.claude-code-*/webview/index.css \
  "$HOME"/.cursor/extensions/anthropic.claude-code-*/webview/index.css ; do
  [ -f "$f" ] || continue
  grep -q custom-bg-fix "$f" || { printf '\n%s\n' "$CSS" >> "$f"; echo "OK: $f"; }
done
echo "Xong -> Reload Window."
