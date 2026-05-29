# Windows: powershell -ExecutionPolicy Bypass -File fix-claude-mask.ps1
# Sau khi chay -> Ctrl+Shift+P -> "Developer: Reload Window".
$css = "`n" + '[class*="toolBodyRowContent_"]:not([class*="disableClipping"]){-webkit-mask-image:linear-gradient(to bottom,#000 50px,transparent 60px)!important;mask-image:linear-gradient(to bottom,#000 50px,transparent 60px)!important}/*custom-bg-fix*/'
Get-ChildItem "$env:USERPROFILE\.vscode\extensions","$env:USERPROFILE\.cursor\extensions" -Directory -Filter "anthropic.claude-code-*" -EA 0 | ForEach-Object {
  $f = Join-Path $_.FullName "webview\index.css"
  if ((Test-Path $f) -and -not (Select-String -Path $f -Pattern "custom-bg-fix" -SimpleMatch -Quiet)) {
    Add-Content -LiteralPath $f -Value $css; Write-Host "OK: $f"
  }
}
Write-Host "Xong -> Reload Window."
