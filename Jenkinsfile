pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-image-classifier'
        DOCKERHUB_REPO = 'sriramakula212/flask-image-classifier'
    }

    stages {
        stage('Clone Repo') {
            steps {
                // Clone the Git repository using Jenkins SCM
                git credentialsId: 'GitHub-Token', url: 'https://github.com/SriramAkula/Human-Activity-Recognition-Using-ResNet50.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image from the Dockerfile in the repository
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Container Tests') {
            steps {
                // Placeholder for running tests in the container, if needed
                sh 'echo "No tests yet. Skipping test stage."'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Push the Docker image to Docker Hub
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        # Log in to Docker Hub
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        
                        # Tag the Docker image with the repository and 'latest' tag
                        docker tag $IMAGE_NAME $DOCKERHUB_REPO:latest
                        
                        # Push the image to Docker Hub
                        docker push $DOCKERHUB_REPO:latest
                    '''
                }
            }
        }
    }
}