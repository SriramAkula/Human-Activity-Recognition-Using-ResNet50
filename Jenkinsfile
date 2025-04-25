pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-image-classifier'
        DOCKERHUB_REPO = 'sriramakula212/flask-image-classifier'
    }

    stages {
        stage('Clone Repo') {
            steps {
                echo 'Code already cloned by Jenkins from GitHub'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Container Tests') {
            steps {
                // Optional: You can skip or replace this with your test command
                sh 'echo "No tests yet. Skipping test stage."'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $IMAGE_NAME $DOCKERHUB_REPO:latest
                        docker push $DOCKERHUB_REPO:latest
                    '''
                }
            }
        }
    }
}
