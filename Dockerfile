FROM tomcat:latest
COPY ./target/hello-world-war-1.0.0.war /usr/local/tomcat/webapps
ENTRYPOINT ["catalina.sh", "run"]
