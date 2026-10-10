# Jenkins LTS + Docker CLI, plugins pre-installed, setup wizard disabled.
# kubectl (the k3s binary) and the kubeconfig are mounted from the host by run.sh.
FROM jenkins/jenkins:lts-jdk21
COPY --from=docker:29-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:29-cli /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/local/libexec/docker/cli-plugins/docker-buildx
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Xmx512m -XX:MaxMetaspaceSize=256m -XX:+UseSerialGC"
RUN jenkins-plugin-cli --plugins workflow-aggregator git docker-workflow pipeline-stage-view timestamper
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
