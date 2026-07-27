FROM tomcat:10.1-jdk21

LABEL maintainer="Vishwanath Vishwakarma"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/java-webapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
