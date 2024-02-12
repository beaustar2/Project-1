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
                    
                    // Stash the resulting WAR file(s)
                    stash(name: "Project-1", includes: "target/*.war")
                }
            }
        }

        stage('Deploy Application') {
            agent {
                label 'tomcat'
            }
            steps {
                script {
                    // Define Tomcat directory and systemd service
                    def tomcatDir = "/home/centos/apache-tomcat-7.0.94"
                    def systemdService = "/etc/systemd/system/tomcat.service"

                    // Create the target directory if it doesn't exist
                    sh "mkdir -p ${tomcatDir}/webapps/"

                    // Remove existing WAR files
                    sh "rm -rf ${tomcatDir}/webapps/*.war"

                    // Unstash the WAR file(s)
                    unstash "Project-1"

                    // Move the WAR file(s) to the target directory
                    sh "mv target/*.war ${tomcatDir}/webapps/"

                    // Reload systemd daemon and restart Tomcat
                    sh "systemctl daemon-reload && systemctl restart tomcat"
                }
            }
        }
    }
}
