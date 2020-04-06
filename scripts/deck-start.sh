#!/usr/bin/env bash

GIT_ROOT=/Users/45ssg168/dev/spinnaker
ARTIFACT=deck
SCRIPTS_DIR=/Users/45ssg168/dev/spinnaker/scripts

LOG_DIR=${GIT_ROOT}/logs
PID_FILE=${GIT_ROOT}/${ARTIFACT}.pid
ARTIFACT_DIR=${GIT_ROOT}/${ARTIFACT}
STOP_SCRIPT=${SCRIPTS_DIR}/${ARTIFACT}-stop.sh

function start() {
  if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR
  fi

 ${STOP_SCRIPT}

  pushd $ARTIFACT_DIR
  export SETTINGS_PATH=~/.spinnaker/settings.js
yarn > /dev/null
yarn start \
    2> ${LOG_DIR}/${ARTIFACT}.err \
    > ${LOG_DIR}/${ARTIFACT}.log &

  while ! nc -z localhost 9000; do sleep 1; done;
  ps -aef | grep [n]ode.*/deck/.*/webpack-dev-server | awk '{print $2}' > $PID_FILE
  popd
}

start
