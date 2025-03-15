# Установщик утилит для проекта Slices
Write-Host "============================================"
Write-Host " Установщик проекта Slices"
Write-Host "============================================"
Write-Host "Проверка и установка необходимых инструментов..."
Write-Host ""

# Функция для скачивания файла
function Download-File {
    param (
        [string]$Url,
        [string]$Output
    )
    Write-Host "Скачивание файла: $Output из $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Output
    if (-Not (Test-Path $Output)) {
        Write-Host "Ошибка: не удалось скачать файл $Output."
        exit 1
    }
}

# Создаем временную папку для распаковки архивов
$tempDir = Join-Path -Path $PWD -ChildPath "temp_extract"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -Path $tempDir -ItemType Directory | Out-Null

# ------------------------
# 1. Установка Pandoc
# ------------------------
if (Test-Path "pandoc.exe") {
    Write-Host "Pandoc уже установлен."
} else {
    Write-Host "Pandoc не найден. Устанавливаю Pandoc..."
    $pandocUrl = "https://github.com/jgm/pandoc/releases/download/2.19.2.1/pandoc-2.19.2.1-windows-x86_64.zip"
    $pandocZip = "pandoc.zip"
    Download-File -Url $pandocUrl -Output $pandocZip
    if (Test-Path $pandocZip) {
        Write-Host "Распаковка Pandoc..."
        Expand-Archive -Path $pandocZip -DestinationPath $tempDir
        $pandocExePath = Join-Path -Path $tempDir -ChildPath "pandoc-2.19.2.1\pandoc.exe"
        if (Test-Path $pandocExePath) {
            Copy-Item -Path $pandocExePath -Destination "pandoc.exe" -Force
            Write-Host "Pandoc успешно установлен."
        } else {
            Write-Host "Ошибка: pandoc.exe не найден в архиве."
            exit 1
        }
        Remove-Item -Path $pandocZip -Force
    } else {
        Write-Host "Ошибка: не удалось скачать архив Pandoc."
        exit 1
    }
}
Write-Host ""

# ------------------------
# 2. Установка Wget
# ------------------------
if (Test-Path "wget.exe") {
    Write-Host "Wget уже установлен."
} else {
    Write-Host "Wget не найден. Устанавливаю Wget..."
    $wgetUrl = "https://eternallybored.org/misc/wget/releases/wget-1.21.3-win64.zip"
    $wgetZip = "wget.zip"
    Download-File -Url $wgetUrl -Output $wgetZip
    if (Test-Path $wgetZip) {
        Write-Host "Распаковка Wget..."
        Expand-Archive -Path $wgetZip -DestinationPath $tempDir
        $wgetExePath = Join-Path -Path $tempDir -ChildPath "wget-1.21.3-win64\wget.exe"
        if (Test-Path $wgetExePath) {
            Copy-Item -Path $wgetExePath -Destination "wget.exe" -Force
            Write-Host "Wget успешно установлен."
        } else {
            Write-Host "Ошибка: wget.exe не найден в архиве."
            exit 1
        }
        Remove-Item -Path $wgetZip -Force
    } else {
        Write-Host "Ошибка: не удалось скачать архив Wget."
        exit 1
    }
}
Write-Host ""

# ------------------------
# 3. Установка yt-dlp
# ------------------------
if (Test-Path "yt-dlp.exe") {
    Write-Host "yt-dlp уже установлен."
} else {
    Write-Host "yt-dlp не найден. Устанавливаю yt-dlp..."
    $ytDlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    Download-File -Url $ytDlpUrl -Output "yt-dlp.exe"
    if (Test-Path "yt-dlp.exe") {
        Write-Host "yt-dlp успешно установлен."
    } else {
        Write-Host "Ошибка: не удалось скачать yt-dlp."
        exit 1
    }
}
Write-Host ""

# Удаляем временную папку
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}

Write-Host "============================================"
Write-Host " Установка завершена."
Write-Host " Если все необходимые инструменты установлены, дополнительных действий не требуется."
Write-Host "============================================"
