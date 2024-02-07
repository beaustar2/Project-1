#Use an official Tomcat runtime as the base image
FROM tomcat:latest

# Copy the WAR file from the target directory to Tomcat webapps
COPY target/*.war /usr/local/tomcat/webapps/