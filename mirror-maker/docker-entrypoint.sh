#!/bin/bash

# Exit immediately if a *pipeline* returns a non-zero status. (Add -x for command tracing)
set -e

#
# Set up the JMX options
#
: ${JMXAUTH:="false"}
: ${JMXSSL:="false"}
if [[ -n "$JMXPORT" && -n "$JMXHOST" ]]; then
    echo "Enabling JMX on ${JMXHOST}:${JMXPORT}"
    export KAFKA_JMX_OPTS="-Djava.rmi.server.hostname=${JMXHOST} -Dcom.sun.management.jmxremote.rmi.port=${JMXPORT} -Dcom.sun.management.jmxremote.port=${JMXPORT} -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=${JMXAUTH} -Dcom.sun.management.jmxremote.ssl=${JMXSSL} "
fi

# Process the argument to this container ...
case $1 in
  start)
    # Copy config files if not provided in volume
    cp -rn ${KAFKA_HOME}/config.orig/* ${KAFKA_HOME}/config

    if [[ -n "$LOG_LEVEL" ]]; then
      sed -i -r -e "s|=INFO, stdout|=$LOG_LEVEL, stdout|g" ${KAFKA_HOME}/config/log4j.properties
      sed -i -r -e "s|^(log4j.appender.stdout.threshold)=.*|\1=${LOG_LEVEL}|g" ${KAFKA_HOME}/config/log4j.properties
    fi
    export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$KAFKA_HOME/config/log4j.properties"

    exec ${KAFKA_HOME}/bin/connect-mirror-maker.sh ${KAFKA_HOME}/config/connect-mirror-maker.properties --clusters ${CLUSTER}
    ;;
esac

# Otherwise just run the specified command
exec "$@"
