FROM tomcat:1.01

COPY web /usr/local/tomcat/webapps/ROOT

EXPOSE 8082
