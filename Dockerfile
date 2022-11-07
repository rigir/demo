FROM openjdk:17-jdk-slim
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

# docker run --rm -d \
#    --name jenkins \
#    -u root \
#    -p 8080:8080 \
#    -v jenkins-data:/var/jenkins_home \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v "$HOME":/home \
#    jenkins/jenkins