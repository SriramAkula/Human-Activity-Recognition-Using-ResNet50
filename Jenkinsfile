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
                // 🧹 Remove all files from the workspace to avoid .git issues
                deleteDir()
            }
        }

        stage('Clone Repo') {
            steps {
                // ⚡ Faster clone with shallow history
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
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Container Tests') {
            steps {
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
