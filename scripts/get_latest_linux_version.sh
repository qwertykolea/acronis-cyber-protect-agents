#!/bin/bash
set -e

# Список зеркал (можно дополнять)
MIRRORS=(
    "https://eu-cloud.acronis.com"
    "https://us-cloud.acronis.com"
    "https://au-cloud.acronis.com"
)

BASE_PATH="/download/u/baas/4.0"
AGENT_FILE="CyberProtect_AgentForLinux_x86_64.bin"

# Временный файл для сбора версий
TMP_FILE=$(mktemp)

for mirror in "${MIRRORS[@]}"; do
    # Получаем список каталогов-версий
    versions=$(curl -s "${mirror}${BASE_PATH}/" | grep -oP 'href="\K[0-9]+\.[0-9]+\.[0-9]+(?=/")' | sort -V)
    for v in $versions; do
        # Проверяем, существует ли файл агента
        if curl -s -I --fail "${mirror}${BASE_PATH}/${v}/${AGENT_FILE}" >/dev/null 2>&1; then
            echo "$v" >> "$TMP_FILE"
        fi
    done
done

# Берём максимальную версию (семантическая сортировка)
if [ -s "$TMP_FILE" ]; then
    latest=$(sort -V "$TMP_FILE" | tail -n1)
    echo "$latest"
else
    echo "ERROR: No versions found" >&2
    exit 1
fi

rm -f "$TMP_FILE"
