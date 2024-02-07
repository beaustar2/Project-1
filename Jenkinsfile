pipeline {
    agent none
    stages {
        stage('Build') {
          agent {
            label "Javawebapp"
          }
            steps {
              echo "Building the project"
              // Define build steps here
                sh '/opt/apache-maven-3.9.5/bin/mvn clean package'
            }
        }
        stage('Test') {
          agent {
            label "Javawebapp"
          }
            steps {
              echo "Running Tests"
              //Define test steps here
                sh "mvn test" 
                stash (name: "JenkinsProject", includes: "target/*.war") 
            }
        }
        stage('Deploy') {
          agent {
            label "Node2"
          }
            steps {
              echo "Deploying the application"
               //Define deployment steps here
                unstash "JenkinsProject" 
                sh "~/apache-tomcat-7.0.94/bin/startup.sh"
                sh "sudo rm -rf ~/apache*/webapp/*.war"
                #sh "sudo mkdir -p /home/centos/apache/webapps/"
                sh "sudo mv target/*.war ~/apache*/webapps/"
                sh "sudo systemctl daemon-reload"
                sh "~/apache-tomcat-7.0.94/bin/startup.sh"
            }
        }
    }
 post {
        success {
            script { 
                // Send email for successful build
              mail to: "Beautypop4sure@gmail.com",
                   subject: "Build Successful - ${currentBuild.fullDisplayName}",
                   body: "Congratulations! The build was successful.\n\nCheck console output at ${BUILD_URL}"
      }
  }            
   failure {
    script { 
        // Send email for failed build
        mail to: "Beautypop4sure@gmail.com",
             subject: "Build Failed - ${currentBuild.fullDisplayName}",
             body: "Oops! The build failed.\n\nCheck console output at ${BUILD_URL}" 
        }
     }
  }      
}
