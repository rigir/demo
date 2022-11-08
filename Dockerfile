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

# docker run \
#   --name jenkins-blueocean \
#   --detach \
#   --network jenkins \
#   --env DOCKER_HOST=tcp://docker:2376 \
#   --env DOCKER_CERT_PATH=/certs/client \
#   --env DOCKER_TLS_VERIFY=1 \
#   --publish 8080:8080 \
#   --publish 50000:50000 \
#   --volume jenkins-data:/var/jenkins_home \
#   --volume jenkins-docker-certs:/certs/client:ro \
#   --volume "$HOME":/home \
#   --restart=on-failure \
#   --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" myjenkins 

#  	01.( Optional ) Specifies the Docker container name for this instance of the Docker image.
# 	02.( Optional ) Runs the current container in the background (i.e. "detached" mode) and outputs the container ID. If you do not specify this option, then the running Docker log for this container is output in the terminal window.
# 	03.Connects this container to the jenkins network defined in the earlier step. This makes the Docker daemon from the previous step available to this Jenkins container through the hostname docker.
# 	04.Specifies the environment variables used by docker, docker-compose, and other Docker tools to connect to the Docker daemon from the previous step.
# 	05.Maps (i.e. "publishes") port 8080 of the current container to port 8080 on the host machine. The first number represents the port on the host while the last represents the container’s port. Therefore, if you specified -p 49000:8080 for this option, you would be accessing Jenkins on your host machine through port 49000.
# 	06.( Optional ) Maps port 50000 of the current container to port 50000 on the host machine. This is only necessary if you have set up one or more inbound Jenkins agents on other machines, which in turn interact with your jenkins-blueocean container (the Jenkins "controller"). Inbound Jenkins agents communicate with the Jenkins controller through TCP port 50000 by default. You can change this port number on your Jenkins controller through the Configure Global Security page. If you were to change the TCP port for inbound Jenkins agents of your Jenkins controller to 51000 (for example), then you would need to re-run Jenkins (via this docker run …​ command) and specify this "publish" option with something like --publish 52000:51000, where the last value matches this changed value on the Jenkins controller and the first value is the port number on the machine hosting the Jenkins controller. Inbound Jenkins agents communicate with the Jenkins controller on that port (52000 in this example). Note that WebSocket agents do not need this configuration.
# 	07.Maps the /var/jenkins_home directory in the container to the Docker volume with the name jenkins-data. Instead of mapping the /var/jenkins_home directory to a Docker volume, you could also map this directory to one on your machine’s local file system. For example, specifying the option
#   08.--volume $HOME/jenkins:/var/jenkins_home would map the container’s /var/jenkins_home directory to the jenkins subdirectory within the $HOME directory on your local machine, which would typically be /Users/<your-username>/jenkins or /home/<your-username>/jenkins. Note that if you change the source volume or directory for this, the volume from the docker:dind container above needs to be updated to match this.
# 	09.Maps the /certs/client directory to the previously created jenkins-docker-certs volume. This makes the client TLS certificates needed to connect to the Docker daemon available in the path specified by the DOCKER_CERT_PATH environment variable.
# 	10.Maps the $HOME directory on the host (i.e. your local) machine (usually the /Users/<your-username> directory) to the /home directory in the container. Used to access local changes to the tutorial repository.
# 	11.Configure the Docker container restart policy to restart on failure as described in the blog post.
# 	12.Allow local checkout for the tutorial. See SECURITY-2478 for the reasons why this argument should not be used on a production installation.
# 	13.The name of the Docker image, which you built in the previous step.