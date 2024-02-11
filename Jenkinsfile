pipeline {
    agent {
        label 'javawebapp'
    }

    stages {
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
                script {
                    sh 'sudo docker build -t beautykemefa/javawebapp:1.3.5 .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                        sh "sudo docker login -u beautykemefa -p ${dockerHubPwd}"
                        sh 'sudo docker push beautykemefa/javawebapp:1.3.5'
                    }
                }
            }
        }

        stage('Run Container on Tomcat-server') {
            steps {
                script {
                    // Generate a unique container name based on the timestamp and Jenkins build ID
                    def containerName = "javaApp-${env.BUILD_ID}-${new Date().format("yyyyMMdd-HHmmss")}"

                    // Stop and remove existing container if it exists
                    sh "sudo docker stop ${containerName} || true"
                    sh "sudo docker rm ${containerName} || true"

                    // Build and run the new container with the unique name
                    def dockerRun = "sudo docker run -p 8080:8080 -d --name ${containerName} beautykemefa/javawebapp:1.3.5"
                    sshagent(['javawebapp']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'sudo docker system prune -af'
            }
        }
    }
}
