FROM tomcat:9-jdk17-temurin

COPY target/*.war /usr/local/tomcat/webapps/app.war

EXPOSE 8080

