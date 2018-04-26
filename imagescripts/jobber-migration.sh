#!/bin/bash

function migrateJobberEnvs() {
  for (( i = 1; ; i++ ))
  do
    local VAR_JOB_ON_ERROR="JOB_ON_ERROR$i"
    local VAR_JOB_NAME="JOB_NAME$i"
    local VAR_JOB_COMMAND="JOB_COMMAND$i"
    local VAR_JOB_TIME="JOB_TIME$i"
    local VAR_JOB_NOTIFY_ERR="JOB_NOTIFY_ERR$i"
    local VAR_JOB_NOTIFY_FAIL="JOB_NOTIFY_FAIL$i"

    if [ ! -n "${!VAR_JOB_NAME}" ]; then
      break
    fi

    local migratedCron=$(echo "${!VAR_JOB_TIME}" | awk '{ $1=""; print}')

    export CRONJOB${i}NAME=${!VAR_JOB_NAME}
    export CRONJOB${i}CRON="$migratedCron"
    export CRONJOB${i}COMMAND="${!VAR_JOB_COMMAND}"

    case "${!VAR_JOB_ON_ERROR}" in
      Continue)
        export CRONJOB${i}ON_ERROR=continue
        ;;
      Stop)
        export CRONJOB${i}ON_ERROR=stop
        ;;
      *)
        export CRONJOB${i}ON_ERROR=continue
        ;;
    esac
  done
}
