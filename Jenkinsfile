pipeline {
    environment {
        registry = 'rigir/lab5_03'
        DOCKERHUB_CREDENTIALS = credentials('docker-login-pwd')
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-17'
                    args '-u root:root'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
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
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-17'
                    args '-u root:root'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'mvn -B -DskipTests clean package' 
            }
        }
        stage('Deploy container') {
             agent{
                docker {
                    image 'mmiotkug/node-curl'
                    args '-p 3000:3000'
                    args '-w /app'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps{
                sh 'docker image build -t $registry:$BUILD_NUMBER .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u rigir --password-stdin'
                sh 'docker image push $registry:$BUILD_NUMBER'
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