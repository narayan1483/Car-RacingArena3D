FROM tomcat:9.0

COPY web /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
