# Use a base image with Java and Tomcat pre-installed
FROM tomcat:latest

# Maintainer information
LABEL maintainer="Your Name <your.email@example.com>"

# Remove the default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file built by Maven to the webapps directory of Tomcat
COPY target/*.war /usr/local/tomcat/webapps/javawebapp.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
