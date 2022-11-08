pipeline {
    environment {
        registry = "rigir/lab5_03"
        DOCKERHUB_CREDENTIALS = credentials('docker-login-pwd')
    }
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
        stage('Build to Docker') {
            agent{
                docker {
                    image 'docker'
                    args '-u root:root'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                    args '-w /app'
                }
            }
            // steps{
            //     sh 'docker image build -t $registry:$BUILD_NUMBER .'
            // }
            steps{
                dockerImage = docker.build("monishavasu/my-react-app:latest")
            }
        }
        stage('Deploying to Dockerhub') {
            agent{
                docker {
                    image 'docker'
                    args '-u root:root'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                    args '-w /app'
                }
            }
            steps{
                echo 'Deploying to docker hub'
                script {
                    docker.withRegistry( 'https://hub.docker.com/', DOCKERHUB_CREDENTIALS ) {
                        dockerImage.push()
                    }
                }
            }
            // post {
            //     always {
            //         sh 'docker logout'
            //     }
            // }
        }
    }
}