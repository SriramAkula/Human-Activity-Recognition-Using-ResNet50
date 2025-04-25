pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES') // ⏱️ Prevents long-running builds
    }

    environment {
        IMAGE_NAME = 'flask-image-classifier'
        DOCKERHUB_REPO = 'sriramakula212/flask-image-classifier'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir() // 🧹 Clean workspace to avoid .git issues
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
                script {
                    sh 'docker pull $DOCKERHUB_REPO:latest || true' // Use cache if available
                    sh 'docker build --cache-from=$DOCKERHUB_REPO:latest -t $IMAGE_NAME .'
                    
                    def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.TAGGED_IMAGE = "${DOCKERHUB_REPO}:${shortCommit}"
                    sh "docker tag $IMAGE_NAME $TAGGED_IMAGE"
                }
            }
        }

        stage('Run Container Tests') {
            steps {
                sh 'echo "No tests yet. Skipping test stage."' // Placeholder
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $IMAGE_NAME $DOCKERHUB_REPO:latest
                        docker push $DOCKERHUB_REPO:latest
                        docker push $TAGGED_IMAGE
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f' // 🧼 Clean up dangling containers/images
        }
    }
}
