# Установщик утилит для проекта Slices
Write-Host "============================================"
Write-Host " Установщик проекта Slices"
Write-Host "============================================"
Write-Host "Проверка и установка необходимых инструментов..."
Write-Host ""

# Функция для скачивания файлов (исправленная)
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

# Создаем временную папку
$tempDir = Join-Path -Path $PWD -ChildPath "temp_extract"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -Path $tempDir -ItemType Directory | Out-Null

# 1. Установка Pandoc (обновленная ссылка)
if (Test-Path "pandoc.exe") {
    Write-Host "Pandoc уже установлен."
} else {
    Write-Host "Pandoc не найден. Устанавливаю..."
    $pandocUrl = "https://github.com/jgm/pandoc/releases/download/3.1.12.1/pandoc-3.1.12.1-windows-x86_64.zip"
    $pandocZip = "pandoc.zip"
    
    Download-File -Url $pandocUrl -Output $pandocZip
    Expand-Archive -Path $pandocZip -DestinationPath $tempDir
    
    $pandocExe = Join-Path $tempDir "pandoc-3.1.12.1\pandoc.exe"
    if (Test-Path $pandocExe) {
        Copy-Item -Path $pandocExe -Destination "pandoc.exe" -Force
        Write-Host "Pandoc установлен успешно."
    } else {
        Write-Host "Ошибка: pandoc.exe не найден в архиве."
        exit 1
    }
    Remove-Item $pandocZip -Force
}

# 2. Установка Wget (проверенная ссылка)
if (Test-Path "wget.exe") {
    Write-Host "Wget уже установлен."
} else {
    Write-Host "Wget не найден. Устанавливаю..."
    $wgetUrl = "https://eternallybored.org/misc/wget/1.21.3/64/wget-1.21.3-win64.zip"
    $wgetZip = "wget.zip"
    
    Download-File -Url $wgetUrl -Output $wgetZip
    Expand-Archive -Path $wgetZip -DestinationPath $tempDir
    
    $wgetExe = Join-Path $tempDir "wget-1.21.3-win64\wget.exe"
    if (Test-Path $wgetExe) {
        Copy-Item -Path $wgetExe -Destination "wget.exe" -Force
        Write-Host "Wget установлен успешно."
    } else {
        Write-Host "Ошибка: wget.exe не найден в архиве."
        exit 1
    }
    Remove-Item $wgetZip -Force
}

# 3. Установка yt-dlp (прямая ссылка)
if (Test-Path "yt-dlp.exe") {
    Write-Host "yt-dlp уже установлен."
} else {
    Write-Host "yt-dlp не найден. Устанавливаю..."
    $ytDlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    Download-File -Url $ytDlpUrl -Output "yt-dlp.exe"
    Write-Host "yt-dlp установлен успешно."
}

# Очистка
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}

Write-Host "`n============================================"
Write-Host " Все компоненты успешно установлены!"
Write-Host "============================================"
