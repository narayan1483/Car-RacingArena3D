FROM tomcat:9.0-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY web/ /usr/local/tomcat/webapps/ROOT/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
