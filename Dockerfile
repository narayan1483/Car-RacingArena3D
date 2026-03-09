FROM tomcat:10.1
COPY web /usr/local/tomcat/webapps/ROOT
EXPOSE 8080
