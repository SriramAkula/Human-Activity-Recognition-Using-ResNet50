pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
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

        stage('Build Docker Image') {
            steps {
                bat 'build.bat'
            }
        }

        stage('Run Container for Testing') {
            steps {
                bat 'run.bat'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker tag flask-image-classifier %DOCKERHUB_REPO%:latest
                        docker push %DOCKERHUB_REPO%:latest
                    '''
                }
            }
        }

        stage('Cleanup Container') {
            steps {
                bat 'stop.bat'
            }
        }
    }
}
