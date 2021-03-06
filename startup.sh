#!/bin/sh
# startup.sh

SONAR_VERSION=8.7
SONARQUBE_HOME=/opt/sonarqube

# Download SonarQube and put it into an ephemeral folder
wget -O /tmp/sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
mkdir /opt
unzip /tmp/sonarqube.zip -d /opt/
mv /opt/sonarqube-$SONAR_VERSION /opt/sonarqube
chmod 0777 -R $SONARQUBE_HOME

# Workaround for ElasticSearch
adduser -DH elasticsearch
echo "su - elasticsearch -c '/bin/sh /home/site/wwwroot/elasticsearch.sh'" > /opt/sonarqube/elasticsearch/bin/elasticsearch

# Install any plugins
# cd $SONARQUBE_HOME/extensions/plugins
# wget https://github.com/hkamel/sonar-auth-aad/releases/download/1.1/sonar-auth-aad-plugin-1.1.jar

# Start the server
cd $SONARQUBE_HOME
exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
#  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
#  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
#  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.port="$WEBSITES_PORT" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom"
