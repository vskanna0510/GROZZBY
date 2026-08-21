Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Sugumaran\.gemini\antigravity-ide\brain\86629f96-723b-425d-95db-9b2924e09108\.user_uploaded\media_1787330799089.png"
$src = [System.Drawing.Image]::FromFile($srcPath)

function Resize-Image($srcImg, $width, $height, $destPath) {
    $dir = [System.IO.Path]::GetDirectoryName($destPath)
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    $dest = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($dest)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.DrawImage($srcImg, 0, 0, $width, $height)
    $dest.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $dest.Dispose()
    Write-Output "Saved: $destPath ($width x $height)"
}

# 1. Assets
Resize-Image $src 512 512 "d:\Grozzby\mobile\assets\images\app_icon.png"
Resize-Image $src 512 512 "d:\Grozzby\mobile\assets\images\logo_bag.png"
Resize-Image $src 512 512 "d:\Grozzby\mobile\assets\images\splash_bag_with_map.png"
Resize-Image $src 512 512 "d:\Grozzby\mobile\assets\icons\app_icon.png"

# 2. Web Icons
Resize-Image $src 64 64 "d:\Grozzby\mobile\web\favicon.png"
Resize-Image $src 192 192 "d:\Grozzby\mobile\web\icons\Icon-192.png"
Resize-Image $src 512 512 "d:\Grozzby\mobile\web\icons\Icon-512.png"
Resize-Image $src 192 192 "d:\Grozzby\mobile\web\icons\Icon-maskable-192.png"
Resize-Image $src 512 512 "d:\Grozzby\mobile\web\icons\Icon-maskable-512.png"

# 3. Android Mipmaps
Resize-Image $src 48 48 "d:\Grozzby\mobile\android\app\src\main\res\mipmap-mdpi\ic_launcher.png"
Resize-Image $src 72 72 "d:\Grozzby\mobile\android\app\src\main\res\mipmap-hdpi\ic_launcher.png"
Resize-Image $src 96 96 "d:\Grozzby\mobile\android\app\src\main\res\mipmap-xhdpi\ic_launcher.png"
Resize-Image $src 144 144 "d:\Grozzby\mobile\android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png"
Resize-Image $src 192 192 "d:\Grozzby\mobile\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"

$src.Dispose()
Write-Output "App icon generation completed successfully!"
