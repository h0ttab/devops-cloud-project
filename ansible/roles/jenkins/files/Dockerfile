FROM jenkins/jenkins:2.568.2

ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc.yaml"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /usr/share/jenkins/ref/casc.yaml
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

USER root