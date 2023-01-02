#!/usr/bin/bash

firewall_url="http://192.168.249.1:1000"
username="<ENTER YOUR USERNAME>"
password="<ENTER YOUR PASSWORD>"

interface="$(route | grep '^default' | grep -o '[^ ]*$')"

echo "Username: $username"
echo "Password: $password"

get_login_page() {
    local output="$(curl --silent \
        --interface "${interface}" -k "${firewall_url}/logout?")"
    echo "${output}" | grep -oE '"htt[^"]*"' | grep -oE 'http[^"]*' 
}

get_magic() {
    local login_page="${1}"; shift
    local output="$(curl --silent \
        --interface "${interface}" -k "${login_page}")"
    local quoted="$(echo "${output}" | grep -oE \
        '"magic" value="[^"]*"' | grep -oE '"[^"]*"$')"
    echo "${quoted}" | grep -oE '[^"]*'
}

do_login() {
    local magic="${1}"; shift
    local output="$(curl -k --interface "${interface}" -X POST --silent \
        -d "username=${username}" \
        -d "password=${password}" \
        -d "magic=${magic}" \
        -d "submit=Continue" \
        "${firewall_url}/" )"
    echo "${output}" | grep -oE 'http[^"]*logout[^"]*'
    echo "${output}" | grep -oE 'http[^"]*keepalive[^"]*'
}

log_out() {
    local url="${1}"; shift
    curl -k --interface "${interface}" --silent "${url}"
}

keep_alive() {
    local url="${1}"; shift
    echo "Keepalive url is" "${url}"
    while :; do
        local output="$(curl -k -silent --interface "${interface}" "${url}")"

        if echo "${output}" | grep -q "leave it open"; then
            echo "Keepalive successful"
            sleep 10
        else
            echo "Keepalive unsuccessful; Trying to get login screen"
            break
        fi
    done
}

main() {
    local output="${1}"; shift
    logout_url=$(echo "$output" | head -1)
    keepalive_url=$(echo "$output" | tail -1)

    echo "${logout_url}"
    echo "${keepalive_url}"

    keep_alive "${keepalive_url}"
}

while :; do
    lpage="$(get_login_page)"
    magic="$(get_magic "${lpage}")"
    lurls="$(do_login "${magic}")"
    main "${lurls}"
    sleep 1
done
