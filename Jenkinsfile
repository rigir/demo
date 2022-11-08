pipeline {
    environment {
        registry = "rigir/lab5_03"
        DOCKERHUB_CREDENTIALS = credentials('docker-login-pwd')
    }
    agent {
        maven {
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
                // sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u rigir --password-stdin'
                // sh 'docker image push $registry:$BUILD_NUMBER'
                // sh "docker image rm $registry:$BUILD_NUMBER"
                withDockerRegistry([ credentialsId: "docker-login-pwd", url: "" ]) {
                    dockerImage.push()
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