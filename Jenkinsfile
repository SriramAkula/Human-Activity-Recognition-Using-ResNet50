pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES') // ⏱️ Prevents checkout timeout
    }

    environment {
        IMAGE_NAME = 'flask-image-classifier'
        DOCKERHUB_REPO = 'sriramakula212/flask-image-classifier'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Clone Repo') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/SriramAkula/Human-Activity-Recognition-Using-ResNet50.git',
                        credentialsId: 'GitHub-Token'
                    ]],
                    extensions: [[$class: 'CloneOption', depth: 1, shallow: true]]
                ])
            }
        }

        stage('Build Image with Docker Compose') {
            steps {
                bat 'docker-compose build'
            }
        }

        stage('Run Container Tests') {
            steps {
                bat 'docker-compose run --rm web echo Container runs successfully!'
            }
        }

        stage('Tag & Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker tag %IMAGE_NAME% %DOCKERHUB_REPO%:latest
                        docker push %DOCKERHUB_REPO%:latest
                    '''
                }
            }
        }
                stage('Run Flask App') {
            steps {
                bat '''
                    docker stop flask-container || echo "No container to stop"
                    docker rm flask-container || echo "No container to remove"
                    docker run -d -p 5000:5000 --name flask-container %IMAGE_NAME%
                '''
            }
        }

    }
}
