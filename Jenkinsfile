pipeline {
    agent any

    environment {
        IMAGE_NAME = 'chinecheremgideon/cw2-server'
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                sh """
                    docker rm -f test-container || true
                    docker run -d --name test-container -p 8081:8081 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    docker ps
                    docker stop test-container && docker rm test-container
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Run Ansible Playbook on Production Server') {
            steps {
                sh """
                    ssh -o StrictHostKeyChecking=no -i ~/.ssh/labsuser.pem ubuntu@34.235.144.156 '
                      cd ~/ansible-k8s &&
                      ansible-playbook cw2-playbook.yml --extra-vars "image_tag=${IMAGE_TAG}"
                    '
                """
            }
        }
    }
}

