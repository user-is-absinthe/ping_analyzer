#!/bin/bash

# Настройки
UNREACHABLE="-1"
REMOTE_SERVER="9.9.9.9"
OUTPUT_FILE="/home/ping_report.csv"  # Явный путь

# Создаем заголовок CSV, если файл не существует
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "date_time;ping_cloudflare;ping_remote" > "$OUTPUT_FILE"
fi

# Получаем текущее время
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# Функция для проверки пинга
check_ping() {
    local host=$1
    result=$(ping -c 1 -W 2 "$host" 2>/dev/null | grep -oP 'time=\K[0-9.]+')
    if [ -z "$result" ]; then
        echo "$UNREACHABLE"
    else
        echo "$result"
    fi
}

# Проверяем пинги
ping_cf=$(check_ping "1.1.1.1")
ping_remote=$(check_ping "$REMOTE_SERVER")

# Записываем результат в CSV
echo "$current_time;$ping_cf;$ping_remote" >> "$OUTPUT_FILE"

