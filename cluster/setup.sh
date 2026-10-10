#!/usr/bin/env bash
# Phase 1 + 3 on the EC2 (Ubuntu 26.04, t3.small): tools, local registry, k3s, helm
set -e
cd "$(dirname "$0")"
sudo apt-get update && sudo apt-get install -y docker.io git
sudo systemctl enable --now docker && sudo usermod -aG docker ubuntu
docker run -d --name registry --restart unless-stopped -p 127.0.0.1:5000:5000 registry:2
sudo mkdir -p /etc/rancher/k3s
sudo cp registries.yaml /etc/rancher/k3s/registries.yaml
sudo cp k3s-config.yaml /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | sh -
mkdir -p ~/.kube && cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo snap install helm --classic
# 2 GB RAM: compressed swap cache in RAM so swapping does not saturate the EBS volume
echo 'w /sys/module/zswap/parameters/compressor - - - - zstd
w /sys/module/zswap/parameters/enabled - - - - Y' | sudo tee /etc/tmpfiles.d/zswap.conf
sudo systemd-tmpfiles --create /etc/tmpfiles.d/zswap.conf
