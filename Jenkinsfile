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

                    // Build and test in a single step
                    catchError {
                        sh "${mvnCMD} clean package test"
                    }
                    stash(name: "Project-1", includes: "target/*.war")
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
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.20 ${dockerRun}"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                sh 'sudo docker logout'
                sh 'sudo docker system prune -af'
            }
        }
    }

    post {
        success {
            script {
                mail to: "Beautypop4sure@gmail.com",
                    subject: "Build and Deployment Successful - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: "Congratulations! The build and deployment were successful.\n\nCheck console output at ${env.BUILD_URL}"
            }
        }
        failure {
            script {
                mail to: "Beautypop4sure@gmail.com",
                    subject: "Build and Deployment Failed - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: "Oops! The build and deployment failed.\n\nCheck console output at ${env.BUILD_URL}"
            }
        }
        always {
            script {
                sh 'sudo docker system prune -af'
            }
        }
    }
}
