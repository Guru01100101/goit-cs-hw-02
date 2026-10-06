#!/bin/bash

declare -A check_list=(
    ["Google"]="https://www.google.com"
    ["GitHub"]="https://www.github.com"
    ["Twitter"]="https://www.twitter.com"
    ["YouTube"]="https://www.youtube.com"
)

check() {
    local url="$1"
    local response

    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    [[ "$response" == "200" ]]
}

printf 'Checking the following websites:\n\n'
for site in "${!check_list[@]}"; do
    url="${check_list[$site]}"
    echo "Checking $site at $url"
    if check "$url"; then
        echo "$site is up."
    else
        echo "$site is down."
    fi
done    