pipeline {
    agent any
    
    tools {
        git 'Default Git' // Make sure this matches your configured Git installation in Jenkins
    }

    environment {
        IMAGE_NAME = 'flask-image-classifier'
        DOCKERHUB_REPO = 'sriramakula212/flask-image-classifier'
        DOCKER_TAG = "${env.BUILD_ID}" // Using build ID as tag for versioning
    }

    stages {
        stage('Clone Repo') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/SriramAkula/Human-Activity-Recognition-Using-ResNet50.git',
                        credentialsId: 'GitHub-Token'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build with both latest and versioned tags
                    sh "docker build -t ${IMAGE_NAME}:${DOCKER_TAG} -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Run Container Tests') {
            steps {
                script {
                    // Example test command - replace with your actual tests
                    sh "docker run --rm ${IMAGE_NAME}:${DOCKER_TAG} python -m pytest tests/"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds', 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        
                        # Tag and push both versions
                        docker tag ${IMAGE_NAME}:${DOCKER_TAG} ${DOCKERHUB_REPO}:${DOCKER_TAG}
                        docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_REPO}:latest
                        
                        docker push ${DOCKERHUB_REPO}:${DOCKER_TAG}
                        docker push ${DOCKERHUB_REPO}:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images to save space
            sh '''
                docker rmi ${IMAGE_NAME}:${DOCKER_TAG} || true
                docker rmi ${IMAGE_NAME}:latest || true
                docker rmi ${DOCKERHUB_REPO}:${DOCKER_TAG} || true
                docker rmi ${DOCKERHUB_REPO}:latest || true
            '''
        }
    }
}