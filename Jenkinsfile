pipeline {
    agent {
        label 'Javawebapp'
    }

    stages {
        stage('SCM Checkout') {
            steps {
                script {
                    git tool: 'Default', credentialsId: 'git-cred', url: 'https://github.com/beaustar2/Project-1.git', branch: 'master'
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

        stage('Deploying to Tomcat-server') {
            agent {
                label "Tomcat"
            }
            steps {
                echo "Deploying the application"
                // Define deployment steps here
                unstash "Project-1" 
                sh "sudo /home/centos/apache-tomcat-7.0.94/bin/startup.sh"
                sh "sudo rm -rf ~/apache*/webapps/*.war"
                sh "sudo mkdir -p /home/centos/apache-tomcat-7.0.94/webapps/"
                sh "sudo mv target/*.war /home/centos/apache-tomcat-7.0.94/webapps/"
                sh "sudo systemctl daemon-reload"
                sh "sudo /home/centos/apache-tomcat-7.0.94/bin/startup.sh"
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
                    def dockerRun = 'sudo docker run -p 8083:8080 -d --name javaApp beautykemefa/javawebapp:1.3.5'
                    sshagent(['nodes-cred']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                sh 'sudo docker logout'
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
    }
}