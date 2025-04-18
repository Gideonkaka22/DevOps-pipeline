pipeline {
    agent any

    environment {
        IMAGE_NAME = 'chinecheremgideon/cw2-server'
        IMAGE_TAG = '1.0'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Gideonkaka22/DevOps-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Test Docker Container') {
            steps {
                sh '''
                    docker run -d --name test-container -p 8081:8081 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    docker ps
                    docker stop test-container && docker rm test-container
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl set image deployment/cw2-server cw2-server=${IMAGE_NAME}:${IMAGE_TAG} --record || \
                    kubectl create deployment cw2-server --image=${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }
}
