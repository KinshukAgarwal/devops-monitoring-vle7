# Jenkins LTS + Docker CLI, plugins pre-installed, setup wizard disabled.
# kubectl is baked in; the k3s kubeconfig and the docker socket are mounted by run.sh.
FROM jenkins/jenkins:lts-jdk21
COPY --from=docker:29-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:29-cli /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/local/libexec/docker/cli-plugins/docker-buildx
USER root
# real kubectl (the k3s multi-call binary would unpack 250 MB into JENKINS_HOME)
RUN curl -fsSLo /usr/local/bin/kubectl https://dl.k8s.io/release/v1.36.5/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl
USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Xmx384m -XX:MaxMetaspaceSize=200m -XX:+UseSerialGC"
RUN jenkins-plugin-cli --plugins workflow-aggregator git docker-workflow pipeline-stage-view timestamper
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
