# Use a base image with Java and Tomcat pre-installed
FROM tomcat:latest

# Remove the default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file built by Maven to the webapps directory of Tomcat
COPY target/*.war /usr/local/tomcat/webapps/javawebapp.war
