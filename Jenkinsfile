pipeline {
    agent none  // Set to 'none' since you'll be specifying agents in each stage

    environment {
        DOCKERHUB_CREDENTIALS = credentials('beautykemefa-dockerhub')
        TOMCAT_SERVER_LABEL = 'tomcat'
        CONTAINER_NAME = 'javaapp'
        DOCKER_IMAGE_NAME = 'beautykemefa/javawebapp'
    }

    stages {
        stage('SCM Checkout') {
            agent any
            steps {
                git 'https://github.com/beaustar2/Project-1.git'
            }
        }

        stage('Build and Test') {
            agent {
                label "Javawebapp"
            }
            steps {
                echo "Building and Testing"
                sh "mvn clean test"
                stash(name: "javawebapp", includes: "target/*.war")
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Remove unused Docker images to avoid conflicts
                    sh "docker rmi ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}" 
                    sh "docker rmi ${DOCKER_IMAGE_NAME}:latest"
                    // Build Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'beautykemefa-dockerhub', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Deploying to Tomcat') {
            agent {
                label "${TOMCAT_SERVER_LABEL}"
            }
            steps {
                echo "Deploying Docker image to Tomcat"
                script {
                    // Run the Docker container on Tomcat
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8080:8080 ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Clean Up') {
            steps {
                sh 'docker logout'
            }
        }
    }

    post {
        success {
            script {
                mail to: "Beautypop4sure@gmail.com",
                    subject: "Build and Deployment Successful - ${currentBuild.fullDisplayName}",
                    body: "Congratulations! The build and deployment were successful.\n\nCheck console output at ${BUILD_URL}"
            }
        }
        failure {
            script {
                mail to: "Beautypop4sure@gmail.com",
                    subject: "Build and Deployment Failed - ${currentBuild.fullDisplayName}",
                    body: "Oops! The build and deployment failed.\n\nCheck console output at ${BUILD_URL}"
            }
        }
    }
}
