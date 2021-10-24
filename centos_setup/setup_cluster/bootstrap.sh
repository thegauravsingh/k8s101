#!/bin/bash
set -x
# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.56.2 kubemaster.cluster.com kubemaster
192.168.56.3 kubenode01.cluster.com kubenode01
192.168.56.4 kubenode02.cluster.com kubenode02
EOF

# Disable SELinux
echo "[TASK 2] Disable SELinux"
getenforce
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
# Reboot your server
# reboot


# Stop and disable firewalld
echo "[TASK 3] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Setup bridge interface
echo "[TASK 3] Setup bridge interface"

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
EOF
sysctl --system

cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
sysctl -p

# Install docker from Docker-ce repository
echo "[TASK 4] Install docker container engine"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
yum install -y -q docker-ce
gpasswd -a vagrant docker

# change cgroupdriver
mkdir -p /etc/docker
touch /etc/docker/daemon.json
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl enable docker
systemctl start docker

docker info | grep -i driver

# DNS Server
echo "[TASK 5] Setup DNS"
echo "nameserver 8.8.8.8">/etc/resolv.conf

# Disable swap
echo "[TASK 6] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Add yum repo file for Kubernetes
echo "[TASK 7] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes
echo "[TASK 8] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum install -y -q kubeadm-1.15.4 kubelet-1.15.4 kubectl-1.15.4

#yum install -y -q kubeadm kubelet kubectl

# Start and Enable kubelet service
echo "[TASK 9] Enable and start kubelet service"
systemctl enable kubelet
systemctl start kubelet

# Enable ssh password authentication
echo "[TASK 10] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 11] Set root password"
echo "admin" | passwd --stdin root

# Install tools
echo "[TASK 12] Install tools"
yum install -y -q vim

# Update vagrant user's bashrc file
echo "[TASK 13] Update vagrant user's bashrc file"
echo "export TERM=xterm" >> /etc/bashrc
echo "alias kcc='kubectl config current-context'" >> /etc/bashrc
echo "alias kuc='kubectl config use-context'" >> /etc/bashrc