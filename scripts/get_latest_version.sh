#!/bin/bash
set -e

# Список зеркал (можно расширить)
MIRRORS=(
    "https://eu-cloud.acronis.com"
    "https://us-cloud.acronis.com"
    "https://au-cloud.acronis.com"
)

BASE_PATH="/download/u/baas/4.0"

# Функция получения списка версий с одного зеркала
fetch_versions() {
    local mirror=$1
    curl -s "${mirror}${BASE_PATH}/" | \
        grep -oP 'href="\K[0-9.]+(?=/")' | \
        sort -V
}

# Собираем все версии со всех зеркал и сортируем
all_versions=""
for mirror in "${MIRRORS[@]}"; do
    versions=$(fetch_versions "$mirror")
    if [ -n "$versions" ]; then
        all_versions="$all_versions"$'\n'"$versions"
    fi
done

# Убираем дубликаты и сортируем по версиям (semver)
latest=$(echo "$all_versions" | sort -V | tail -n1)

if [ -z "$latest" ]; then
    echo "ERROR: No versions found" >&2
    exit 1
fi

echo "$latest"