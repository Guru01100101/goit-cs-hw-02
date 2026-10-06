#!/bin/bash

# Задаємо масив з назвами сайтів та їх URL
declare -A check_list=(
    ["Google"]="https://google.com"
    ["GitHub"]="https://github.com"
    ["Twitter"]="https://twitter.com"
    ["YouTube"]="https://youtube.com"
    ["HTTP_200"]="https://httpbin.org/status/200"
    ["HTTP_403"]="https://httpbin.org/status/403"
    ["HTTP_404"]="https://httpbin.org/status/404"
    ["HTTP_500"]="https://httpbin.org/status/500"
    ["HTTP_503"]="https://httpbin.org/status/503"
)

# Задаємо шлях до файлу логів
log_file="$PWD/website_status.log"

check() {
    # Функція перевіряє доступність сайту за допомогою curl

    # Аргументи:
    # $1 - URL сайту
    # $2 - Необов'язкова назва сайту
    local url="$1"
    local site="${2:-Not specified}"
    local response
    local status

    # Використовуємо curl для отримання HTTP статусу сайту
    response=$(curl -sL --max-time 10 \
                    --output /dev/null \
                    --write-out "%{http_code}" "$url")
    # Присвоюємо статус на основі отриманого коду відповіді
    if [[ "$response" == "200" ]] 
    then
        status="available"
    else
        status="unavailable ($response)"
    fi

    # Логування результатів перевірки у файл
    printf '%s | %s | %s | %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" "$site" "$url" "$status" \
        >> "$log_file"
    
    # Повертаємо результат перевірки true/false
    [[ "$response" == "200" ]]
}

printf 'Checking the following websites:\n\n'
for site in "${!check_list[@]}"; do
    url="${check_list[$site]}"
    if check "$url" "$site"
    then
        echo "$site is up."
    else
        echo "$site is down."
    fi
done    