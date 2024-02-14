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
                    withCredentials([usernamePassword(credentialsId: 'docker-pwd', passwordVariable: 'docker-pwd', usernameVariable: 'dockerHubPwd')]) {
                        sh "sudo docker login -u beautykemefa -p ${dockerHubPwd}"
                        sh 'sudo docker push beautykemefa/javawebapp:1.3.5'
                    }
                }
            }
        }

        stage('Run Container on Tomcat-server') {
            steps {
                script {
                    def dockerRun = 'sudo docker run -p 8080:8080 -d --name javaApp beautykemefa/javawebapp:1.3.5'
                    sshagent(['nodes']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                sh 'docker logout'
                sh 'sudo docker system prune -af'
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
        always {
            script {
                sh 'sudo docker system prune -af'
            }
        }
    }
}
