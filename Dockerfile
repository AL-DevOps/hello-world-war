FROM tomcat:latest
COPY ./target/*.war /usr/local/tomcat/webapps
ENTRYPOINT ["catalina.sh", "run"]
