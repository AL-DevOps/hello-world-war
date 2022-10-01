FROM ubuntu:latest
COPY . .
RUN apt-get update
RUN apt install -y maven
RUN mvn compile
RUN mvn test
RUN mvn package
