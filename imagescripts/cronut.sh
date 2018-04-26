#!/bin/bash

set -o errexit

[[ ${DEBUG} == true ]] && set -x

java -cp ${CRONUT_HOME}/crow-application.jar -Dloader.main=com.blacklabelops.crow.application.cli.CrowCli org.springframework.boot.loader.PropertiesLauncher "$@"
