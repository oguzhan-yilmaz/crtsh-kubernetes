#!/bin/bash

HOST="$1"

CHT_SH_RESULT=$(curl --silent --get \
    --data-urlencode "q=${HOST}" \
    --data-urlencode "deduplicate=Y" \
    --data-urlencode "exclude=expired" \
    https://crt.sh/json)

printf "%-30s %-22s %-8s %s\n" "CNAME" "NOT_AFTER" "CA_ID" "SERIAL_ID"
echo "$CHT_SH_RESULT" | jq 'map(del(.issuer_name))' | jq -c '.[]'  |  while read entry; do
    # echo "$entry"
    common_name=$(echo "$entry" | jq -r '.common_name') 
    not_after=$(echo "$entry" | jq -r '.not_after') 
    issuer_ca_id=$(echo "$entry" | jq -r '.issuer_ca_id') 
    not_before=$(echo "$entry" | jq -r '.not_before') 
    serial_number=$(echo "$entry" | jq -r '.serial_number') 
    
    domain="https://${common_name}"
    printf "%-30s %-22s %-8s %s\n" "$common_name" "$not_after" "$issuer_ca_id" "$serial_number"
done

printf "\n\nACCESSIBLE_RECORDS:\n"

echo "$CHT_SH_RESULT" | jq -s '.[]| map(.common_name) | unique' | jq -r '.[]' | while read common_name; do
    domain="https://${common_name}"
    if curl -s -k -m 5 "$domain" > /dev/null 2>&1; then
        printf "%s\n" "$domain"
    fi
done
