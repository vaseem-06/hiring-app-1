FROM tomcat:8.0.20-jre8
LABEL maintainer="vaseem06"

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your built WAR into Tomcat
COPY target/hiring-0.1.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
