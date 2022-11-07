FROM maven:3-openjdk-17-slim AS base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

FROM base as test
CMD ["./mvnw", "test"]

FROM base as build
RUN ./mvnw package

FROM openjdk:17-jdk-slim as production
COPY --from=build /app/target/output.jar /output.jar
CMD ["java", "-jar", "/output.jar"]

FROM maven:3-openjdk-17-slim AS base
WORKDIR /app
COPY .mvn/ .mvn
COPY pom.xml ./
RUN mvn dependency:resolve
COPY src ./src

FROM base as build
RUN mvn package

FROM openjdk:17-jdk-slim as production
COPY --from=build /app/target/output.jar /output.jar
CMD ["java", "-jar", "/output.jar"]