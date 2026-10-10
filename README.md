# devops-monitoring-vle7

VLE-7 Full DevOps Monitoring System: GitHub → Jenkins (Poll SCM) → Docker image → k3s → Prometheus/Grafana → Alertmanager.

| Path | Purpose |
|---|---|
| `Dockerfile`, `index.html` | demo app (nginx) built by Jenkins |
| `Jenkinsfile` | Build (docker build + push to local registry) → Deploy (`kubectl apply -f deployment.yaml`) |
| `deployment.yaml` | `myapp` Deployment (2 replicas) + Service |
| `jenkins-setup/` | Jenkins image (wizard off, JVM capped, docker CLI), job + admin user via init Groovy |
| `monitoring/` | kube-prometheus-stack values (trimmed for 2 GB), PrometheusRule, webhook receiver, crash-loop test pod |
