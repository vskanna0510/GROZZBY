# Downloads Figma MCP assets and saves with correct extension (.svg or .png)
$assets = @{
  "images/logo_full.png" = "https://www.figma.com/api/mcp/asset/144fa3f7-6272-42ba-927f-92535f8c44dc"
  "images/splash_zoom.png" = "https://www.figma.com/api/mcp/asset/33158b6d-f59c-4a6e-a48b-7ac29b55985e"
  "images/logo_bag.png" = "https://www.figma.com/api/mcp/asset/33158b6d-f59c-4a6e-a48b-7ac29b55985e"
  "images/splash_graphic.png" = "https://www.figma.com/api/mcp/asset/061cc02e-159c-4141-affa-b13e93356511"
  "images/onboarding_logo.png" = "https://www.figma.com/api/mcp/asset/b1290c0e-070c-4c37-94aa-0a76764caaed"
  "images/onboarding_bag.png" = "https://www.figma.com/api/mcp/asset/dd4d657b-88eb-4676-9fdc-4845143db03d"
  "images/onboarding_star.png" = "https://www.figma.com/api/mcp/asset/6d6609a9-549a-490e-88b1-cf427ce296eb"
  "images/onboarding_heart.png" = "https://www.figma.com/api/mcp/asset/2895d2b9-666e-422d-9e7b-1582874727cf"
  "images/onboarding_truck.png" = "https://www.figma.com/api/mcp/asset/659cd219-14a4-4f5a-af0a-81d5476cf3fa"
  "images/onboarding_tag.png" = "https://www.figma.com/api/mcp/asset/61da2f0d-42af-4c3c-8cb6-cee8edb8f135"
  "images/welcome_circle.svg" = "https://www.figma.com/api/mcp/asset/4124ff8f-b8dc-4cef-872d-654219d7b253"
  "images/checkmark.svg" = "https://www.figma.com/api/mcp/asset/665c9328-ff76-488c-999c-62c172d56419"
  "images/shop_bag_button.png" = "https://www.figma.com/api/mcp/asset/f69a45e4-6efd-4e2d-96b7-d22000f5da4c"
  "images/otp_progress.svg" = "https://www.figma.com/api/mcp/asset/7145df8c-468a-4b41-90a5-efa557490ae0"
  "icons/check_circle.svg" = "https://www.figma.com/api/mcp/asset/c49c42a6-b6e8-4cc8-a83d-8368e24e95a0"
  "icons/icon_profile.svg" = "https://www.figma.com/api/mcp/asset/910edcf8-e2bb-4869-a2c5-3c0bcef16e15"
  "icons/icon_email.svg" = "https://www.figma.com/api/mcp/asset/c81e430d-a1ef-42eb-b429-a28f3eeb311e"
  "icons/icon_phone.svg" = "https://www.figma.com/api/mcp/asset/e7803221-0748-40fd-9500-09f34bd0d529"
  "icons/icon_password.svg" = "https://www.figma.com/api/mcp/asset/d3099913-4aea-4a50-8512-c6b58f742c81"
  "icons/icon_visibility.svg" = "https://www.figma.com/api/mcp/asset/6311811b-6452-46ff-9a51-7abfa1a32376"
  "icons/icon_facebook.svg" = "https://www.figma.com/api/mcp/asset/3a21df65-c9c1-4efa-b5d4-22227cba0958"
  "icons/icon_google.svg" = "https://www.figma.com/api/mcp/asset/5133c340-1ec7-44b1-82cf-297645cc852a"
  "icons/icon_apple.svg" = "https://www.figma.com/api/mcp/asset/ac751b2c-571c-4ac4-b0c0-42427b778415"
  "icons/icon_email_otp.svg" = "https://www.figma.com/api/mcp/asset/19fcc8c0-754c-4e4c-8f92-54c34c546d2f"
  "icons/icon_phone_otp.svg" = "https://www.figma.com/api/mcp/asset/ad1468e5-62f6-4bde-b9ce-0256a7326ef6"
  "images/chevron.svg" = "https://www.figma.com/api/mcp/asset/51f30ad2-c174-45b0-b384-5271da8f1c10"
}

$base = "d:\Grozzby\mobile\assets"
$client = New-Object System.Net.WebClient

foreach ($entry in $assets.GetEnumerator()) {
  $dest = Join-Path $base $entry.Key
  $dir = Split-Path $dest -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  try {
    $bytes = $client.DownloadData($entry.Value)
  } catch {
    Write-Host "FAILED: $($entry.Key) - $_"
    continue
  }

  $header = [Text.Encoding]::ASCII.GetString($bytes[0..([Math]::Min(15, $bytes.Length - 1))])
  if ($header.StartsWith("<svg") -and $dest.EndsWith(".png")) {
    $dest = $dest -replace '\.png$', '.svg'
  }

  [System.IO.File]::WriteAllBytes($dest, $bytes)
  Write-Host "Saved: $dest ($($bytes.Length) bytes)"
}

Get-ChildItem "$base\icons\*.png" -ErrorAction SilentlyContinue | Remove-Item -Force
