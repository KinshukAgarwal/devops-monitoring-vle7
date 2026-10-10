#!/usr/bin/env bash
# Phase 4 + 5: kube-prometheus-stack, alert rules, webhook receiver
set -e
cd "$(dirname "$0")"
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
[ -f ~/lab-secrets/grafana_admin_password ] || (umask 077; openssl rand -base64 18 | tr -d "\n" > ~/lab-secrets/grafana_admin_password)
kubectl -n monitoring create secret generic grafana-admin --from-literal=admin-user=admin \
  --from-file=admin-password="$HOME/lab-secrets/grafana_admin_password" --dry-run=client -o yaml | kubectl apply -f -
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml --wait --timeout 15m
kubectl apply -f webhook-receiver.yaml -f alert-rules.yaml
