
<!-- In order to execute Docker commands inside Jenkins nodes, download and run the docker:dind Docker image using the following docker run command: -->

<!-- docker network create jenkins -->

<!-- docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  --publish 3000:3000 --publish 5000:5000 \
  docker:dind \
  --storage-driver overlay2  -->

# 01.( Optional ) Specifies the Docker container name to use for running the image. By default, Docker will generate a unique name for the container.
# 02.( Optional ) Automatically removes the Docker container (the instance of the Docker image) when it is shut down.
# 03.( Optional ) Runs the Docker container in the background. This instance can be stopped later by running docker stop jenkins-docker.
# 04.Running Docker in Docker currently requires privileged access to function properly. This requirement may be relaxed with newer Linux kernel versions.
# 05.This corresponds with the network created in the earlier step.
# 06.Makes the Docker in Docker container available as the hostname docker within the jenkins network.
# 07.Enables the use of TLS in the Docker server. Due to the use of a privileged container, this is recommended, though it requires the use of the shared volume described below. This environment variable controls the root directory where Docker TLS certificates are managed.
# 08.Maps the /certs/client directory inside the container to a Docker volume named jenkins-docker-certs as created above.
# 09.Maps the /var/jenkins_home directory inside the container to the Docker volume named jenkins-data. This will allow for other Docker containers controlled by this Docker container’s Docker daemon to mount data from Jenkins.
# 10.( Optional ) Exposes the Docker daemon port on the host machine. This is useful for executing docker commands on the host machine to control this inner Docker daemon.
# 11.Exposes ports 3000 and 5000 from the docker in docker container, used by some of the tutorials.
# 12.The docker:dind image itself. This image can be downloaded before running by using the command: docker image pull docker:dind.
# 13.The storage driver for the Docker volume. See "Docker storage drivers" for supported options.

