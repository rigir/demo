pipeline {
    environment {
        registry = 'rigir/lab5_03'
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
        stage('Deploying to Dockerhub') {
            agent{
                docker {
                    image 'mmiotkug/node-curl'
                    args '-p 3000:3000'
                    args '-w /app'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            stages {
                stage('Build to container') {
                    steps{
                        sh 'docker image build -t $registry:$BUILD_NUMBER .'
                    }
                }
                stage('Deploy container') {
                    steps{
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u rigir --password-stdin'
                        sh 'docker image push $registry:$BUILD_NUMBER'
                        sh 'docker logout'
                        sh 'docker image rm $registry:$BUILD_NUMBER'
                    }
                    post {
                        always {
                            sh 'docker logout'
                        }
                    }
                }
            }
        }
    }
}