pipeline {
    agent any

    environment {
        IMAGE_NAME = 'chinecheremgideon/cw2-server'
        IMAGE_TAG = '1.0'
    }

    stages {
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

    }
}

