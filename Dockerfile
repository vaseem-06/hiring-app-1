FROM tomcat:8.0.20-jre8
LABEL maintainer="vaseem06"

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the built WAR file into Tomcat
COPY target/hiring.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
