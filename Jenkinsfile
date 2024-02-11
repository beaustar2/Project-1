pipeline {
    agent {
        label 'javawebapp'
    }

    stages {
        stage('Cleanup Container') {
            steps {
                sh 'docker stop javaApp || true'
                sh 'docker rm javaApp || true'
            }
        }

        stage('SCM Checkout') {
            steps {
                script {
                    git tool: 'Default', credentialsId: 'git-creds', url: 'https://github.com/beaustar2/Project-1.git', branch: 'main'
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
                sh 'docker build -t beautykemefa/javawebapp:1.3.5 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                    sh "docker login -u beautykemefa -p ${dockerHubPwd}"
                }
                sh 'docker push beautykemefa/javawebapp:1.3.5'
            }
        }

        stage('Run Container on Tomcat-server') {
            steps {
                script {
                    def dockerRun = 'docker run -p 8080:8080 -d --name javaApp beautykemefa/javawebapp:1.3.5'
                    sshagent(['javawebapp']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
                    }
                }
            }
        }
    }
}
