#!/bin/bash

set -o errexit

[[ ${DEBUG} == true ]] && set -x && LOG4J_LOG_LEVEL=debug

source ${CRONUT_HOME}/create-config.sh

source ${CRONUT_HOME}/jobber-migration.sh

source $CRONUT_HOME/create-log-config.sh

if [ ! -e "application.properties" ]; then
  createPropertyFile
  createConfig
fi

if [ ! -e "log4j.xml" ]; then
  createLogConfig
fi

if [ -n "${CRONUT_UID}" ]; then
  createCustomUser $CRONUT_UID $CRONUT_GID
fi

if [ "${DEBUG}" = 'true' ]; then
  cat application.yml
  cat log4j.xml
fi

if [ -n "${CRONUT_BASE_URL}" ]; then
  export CROW_BASE_URL=${CRONUT_BASE_URL}
fi

if [ "$1" = 'cronut-daemon' ] || [ "${1:0:1}" = '-' ]; then
  migrateJobberEnvs
  if [ -n "${CRONUT_UID}" ]; then
      printUserInfo
      exec su-exec cronut java ${JAVA_OPTS} -Dlogging.config=log4j.xml -jar ${CRONUT_HOME}/crow-application.jar "$@"
  else
    exec java ${JAVA_OPTS} -Dlogging.config=log4j.xml -jar ${CRONUT_HOME}/crow-application.jar "$@"
  fi
else
  if [ -n "${CRONUT_UID}" ]; then
    printUserInfo
    exec su-exec cronut "$@"
  else
    exec "$@"
  fi
fi
