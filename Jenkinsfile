pipeline {
<<<<<<< HEAD
    agent {
        label 'javawebapp'
=======
    agent any  // Set to 'none' since you'll be specifying agents in each stage

    environment {
        DOCKERHUB_CREDENTIALS = credentials('beautykemefa-dockerhub')
        TOMCAT_SERVER_LABEL = 'tomcat'
        CONTAINER_NAME = 'javaapp'
        DOCKER_IMAGE_NAME = 'beautykemefa/javawebapp'
>>>>>>> dfa0c87b7c1cec0d0cd134362ccbaeab5ec73852
    }

    stages {
        stage('Cleanup Container') {
            steps {
<<<<<<< HEAD
                sh 'docker stop javaApp || true'
                sh 'docker rm javaApp || true'
=======
                git branch: 'main', url: 'https://github.com/beaustar2/Project-1.git'
>>>>>>> dfa0c87b7c1cec0d0cd134362ccbaeab5ec73852
            }
        }

        stage('SCM Checkout') {
            steps {
                script {
                    git credentialsId: 'git-creds', url: 'https://github.com/beaustar2/Project-1.git', branch: 'main'
                }
            }
        }

        stage('Mvn Package') {
            steps {
                script {
                    def mvnHome = tool name: 'apache-maven-3.9.5', type: 'maven'
                    def mvnCMD = "${mvnHome}/bin/mvn"
                    sh "${mvnCMD} clean package"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'sudo docker build -t beautykemefa/javawebapp:1.3.5 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                    sh "sudo docker login -u beautykemefa -p ${dockerHubPwd}"
                }
                sh 'sudo docker push beautykemefa/javawebapp:1.3.5'
            }
        }

        stage('Run Container on Tomcat-server') {
            steps {
                script {
                    def dockerRun = 'sudo docker run -p 8080:8080 -d --name javaApp beautykemefa/javawebapp:1.3.5'
                    sshagent(['javawebapp']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
                    }
                }
            }
        }
    }
}
