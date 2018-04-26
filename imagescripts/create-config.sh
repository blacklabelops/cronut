#!/bin/bash

function createCustomUser {
    local userid=$1
    local groupid=$2
    if [ -n "${groupid}" ]; then
        addgroup -g $groupid cronut
    else
        addgroup cronut
    fi
    adduser -G cronut -s /bin/bash -u $userid -h /home/cronut -S cronut
    export HOME=/home/cronut
}

function printUserInfo {
    local userid=$(id -u cronut)
    local groupid=$(id -g cronut)
    echo "Starting user with Group-Id: $groupid"
    echo "Starting user with User-Id: $userid"
}

function createConfig {
    touch application.yml
    cat > application.yml <<_EOF_
---

_EOF_
}

function createPropertyFile {
    touch application.properties
    cat > application.properties <<_EOF_
spring.main.banner-mode=off
spring.config.location=${CRONUT_HOME}application.yml
spring.jackson.serialization.WRITE_DATES_AS_TIMESTAMPS=false
_EOF_
}
