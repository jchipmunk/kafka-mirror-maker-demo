ARG DEBEZIUM_VERSION
FROM quay.io/debezium/kafka:${DEBEZIUM_VERSION}

USER root

ARG JMX_AGENT_VERSION=0.20.0
ARG METRICS_PORT=7071
RUN curl -so ${KAFKA_HOME}/libs/jmx_prometheus_javaagent.jar \
    https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_AGENT_VERSION}/jmx_prometheus_javaagent-${JMX_AGENT_VERSION}.jar
COPY --chown=kafka:kafka config/kafka-mirror-maker.yml ${KAFKA_HOME}/config/kafka-mirror-maker.yml
ENV KAFKA_OPTS="-javaagent:$KAFKA_HOME/libs/jmx_prometheus_javaagent.jar=$METRICS_PORT:$KAFKA_HOME/config/kafka-mirror-maker.yml"
COPY --chown=kafka:kafka config/connect-mirror-maker.properties ${KAFKA_HOME}/config/connect-mirror-maker.properties
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

USER kafka

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
