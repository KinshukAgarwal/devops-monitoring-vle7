#!/usr/bin/env bash
# Jenkins on the EC2: host network but bound to 127.0.0.1, JVM capped at 512 MB.
# Docker socket -> builds images on the host daemon; k3s binary as kubectl + k3s kubeconfig -> deploys to the cluster.
set -e
cd "$(dirname "$0")"
[ -f ~/lab-secrets/jenkins_admin_password ] || (umask 077; openssl rand -base64 18 | tr -d "\n" > ~/lab-secrets/jenkins_admin_password)
docker build -t jenkins-k8s-lab .
docker rm -f jenkins 2>/dev/null || true
docker run -d --name jenkins --restart unless-stopped --network host \
  -e JENKINS_OPTS="--httpListenAddress=127.0.0.1" \
  -e KUBECONFIG=/etc/k3s.yaml \
  --group-add "$(stat -c %g /var/run/docker.sock)" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc/rancher/k3s/k3s.yaml:/etc/k3s.yaml:ro \
  -v /usr/local/bin/k3s:/usr/local/bin/kubectl:ro \
  -v ~/lab-secrets/jenkins_admin_password:/run/secrets/jenkins_admin_password:ro \
  -v jenkins_home:/var/jenkins_home \
  jenkins-k8s-lab
