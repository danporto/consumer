## Estágio 1 — compilar (gera o target/quarkus-app/)
FROM registry.access.redhat.com/ubi9/openjdk-17:1.24 AS build
COPY --chown=185 . /code
WORKDIR /code
RUN microdnf install -y gzip unzip --nodocs && ./mvnw package -DskipTests -B

## Estágio 2 — IDÊNTICO ao Dockerfile.jvm oficial do Quarkus,
## apenas com os COPY vindo do estágio de build (--from=build)
FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:1.24
ENV LANGUAGE='en_US:en'
COPY --from=build --chown=185 /code/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /code/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /code/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /code/target/quarkus-app/quarkus/ /deployments/quarkus/
EXPOSE 8080
USER 185
ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"
ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]