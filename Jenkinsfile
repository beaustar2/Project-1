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
                    sh "${mvnCMD} clean package test"
                    stash(name:"Project-1", includes:"target/*.war")
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo "Deploying the application"
                script {
                    unstash "Project-1"
                    sh"/home/centos/apache-tomcat-7.0.94/bin/startup.sh"
                    sh "sudo rm -rf ~/apache*/webapps/*.war"
                    sh "sudo mv target/*.war ~/apache*/webapps/"
                    sh "sudo systemctl daemon-reload"
                    sh "/home/centos/apache-tomcat-7.0.94/bin/startup.sh"
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
            agent {
                label 'tomcat'
            }
            steps {
                script {
                    def containerName = "javaApp-${env.BUILD_ID}-${new Date().format("yyyyMMdd-HHmmss")}"

                    sh "sudo docker stop ${containerName} || true"
                    sh "sudo docker rm ${containerName} || true"

                    def dockerRun = "sudo docker run -p 8080:8080 -d --name ${containerName} beautykemefa/javawebapp:1.3.5"
                    sshagent(['javawebapp']) {
                        sh "ssh -o StrictHostKeyChecking=no centos@18.218.32.42 ${dockerRun}"
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
