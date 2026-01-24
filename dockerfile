FROM ubuntu:latest
WORKDIR /app
RUN apt update && apt install -y java-21-amazon-corretto \
     java-21-amazon-corretto-devel
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
