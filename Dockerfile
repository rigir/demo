FROM maven:3-openjdk-17-slim AS base
WORKDIR /app
COPY .mvn/ .mvn
COPY pom.xml ./
RUN mvn dependency:resolve
COPY src ./src

FROM base as build
RUN mvn package

FROM openjdk:17-jdk-slim 
COPY --from=build /app/target/output.jar /output.jar
CMD ["java", "-jar", "/output.jar"]