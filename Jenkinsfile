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
                    stash(name: "Project-1", includes: "target/*.war")
                }
            }
        }

        stage('Deploy Application') {
            agent {
                label 'tomcat'
            }
            steps {
                echo "Deploying the application"
                script {
                    // Create the target directory if it doesn't exist
                    sh "sudo mkdir -p /home/centos/apache-tomcat-7.0.94/webapps/"

                    // Remove existing WAR files
                    sh "sudo rm -rf /home/centos/apache-tomcat-7.0.94/webapps/*.war"

                    unstash "Project-1"

                    // Move the WAR file to the target directory
                    sh "sudo mv target/*.war /home/centos/apache-tomcat-7.0.94/webapps/"

                    // Reload systemd daemon
                    sh "sudo systemctl daemon-reload"

                    // Restart Tomcat
                    sh "/home/centos/apache-tomcat-7.0.94/bin/startup.sh"
                }
            }
        }
    }
}
