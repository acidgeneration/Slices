# Установщик утилит для проекта Slices
Write-Host "============================================"
Write-Host " Установщик проекта Slices"
Write-Host "============================================"
Write-Host "Проверка и установка необходимых инструментов..."
Write-Host ""

function Download-File {
    param (
        [string]$Url,
        [string]$Output
    )
    Write-Host "Скачивание: $Output из $Url"
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $Output -UserAgent "SlicesInstaller"
        if (-Not (Test-Path $Output)) {
            throw "Файл не скачан"
        }
    }
    catch {
        Write-Host "Ошибка загрузки: $($_.Exception.Message)"
        exit 1
    }
}

$tempDir = Join-Path -Path $PWD -ChildPath "temp_extract"
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -Path $tempDir -ItemType Directory | Out-Null

# 1. Установка Pandoc
if (-not (Test-Path "pandoc.exe")) {
    Write-Host "Установка Pandoc..."
    $pandocUrl = "https://github.com/pandoc-extras/pandoc-portable/releases/download/2.0.3/pandoc-2.0.3-windows.zip"
    $pandocZip = "pandoc.zip"
    
    Download-File -Url $pandocUrl -Output $pandocZip
    Expand-Archive -Path $pandocZip -DestinationPath $tempDir
    
    $pandocExe = Join-Path $tempDir "pandoc-2.0.3-windows\pandoc.exe"
    if (Test-Path $pandocExe) {
        Copy-Item -Path $pandocExe -Destination "pandoc.exe" -Force
        Write-Host "Pandoc 2.0.3 установлен"
    } else {
        Write-Host "Ошибка: pandoc.exe не найден!"
        Get-ChildItem -Path $tempDir -Recurse | Select-Object FullName
        exit 1
    }
    Remove-Item $pandocZip -Force
}

# 2. Установка Wget
if (-not (Test-Path "wget.exe")) {
    Write-Host "Установка Wget..."
    $wgetUrl = "https://eternallybored.org/misc/wget/releases/wget-1.21.4-win64.zip"
    $wgetZip = "wget.zip"
    
    Download-File -Url $wgetUrl -Output $wgetZip
    Expand-Archive -Path $wgetZip -DestinationPath $tempDir
    
    $wgetExe = Join-Path $tempDir "wget.exe"
    if (Test-Path $wgetExe) {
        Copy-Item -Path $wgetExe -Destination "wget.exe" -Force
        Write-Host "Wget 1.21.4 установлен"
    } else {
        Write-Host "Ошибка: wget.exe не найден!"
        Get-ChildItem -Path $tempDir -Recurse | Select-Object FullName
        exit 1
    }
    Remove-Item $wgetZip -Force
}

# 3. Установка yt-dlp
if (-not (Test-Path "yt-dlp.exe")) {
    Write-Host "Установка yt-dlp..."
    $ytDlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    
    Download-File -Url $ytDlpUrl -Output "yt-dlp.exe"
    Write-Host "yt-dlp установлен"
}

# Очистка временных файлов
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }

Write-Host "`n============================================"
Write-Host " ВСЕ КОМПОНЕНТЫ УСПЕШНО УСТАНОВЛЕНЫ"
Write-Host " Доступные утилиты:"
Get-ChildItem *.exe | Select-Object Name, @{n="Размер";e={"{0:N1} MB" -f ($_.Length/1MB)}}
Write-Host "============================================"
