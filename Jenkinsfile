pipeline {
    agent {
        label 'javawebapp'
    }

    stages {
        // ... (previous stages remain unchanged)

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
                    sh "ssh -o StrictHostKeyChecking=no centos@10.0.1.11 ${dockerRun}"
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
