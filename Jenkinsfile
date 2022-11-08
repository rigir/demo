pipeline {
    agent {
        docker {
            image 'maven:3.8.6-amazoncorretto-17'
            args '-u root:root'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') {
             steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package' 
            }
        }
        stage('Deploying to Dockerhub') {
            steps{
                environment {
                    registry = "rigir/lab5_03"
                    DOCKERHUB_CREDENTIALS = 'docker-login-pwd'
                }
                script {
                    docker.withRegistry( 'https://hub.docker.com/', DOCKERHUB_CREDENTIALS ) {
                        docker.image("${registry}:latest").push()
                    }
                }
            }
        }
    }
}