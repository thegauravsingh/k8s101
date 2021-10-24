#!/bin/bash
set -x
systemctl enable kubelet && systemctl start kubelet

echo "[TASK 1] Join node to Kubernetes Cluster"
mkdir /home/vagrant/.kube
sudo cp -i /data-from-host/config /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

mkdir -p $HOME/.kube
sudo cp -i /data-from-host/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Join worker nodes to the Kubernetes cluster
echo "[TASK 2] Join node to Kubernetes Cluster"
#yum install -q -y sshpass >/dev/null 2>&1
#sshpass -p "admin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kubemaster.cluster.com:/data-from-host/joincluster.sh /data-from-host/joincluster.sh 2>/dev/null
bash /data-from-host/joincluster.sh 

echo "[Final TASK] Setup firewalld"
yum install firewalld -y
systemctl enable firewalld && systemctl start firewalld
 
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10256/tcp
firewall-cmd --permanent --add-port=10257/tcp
firewall-cmd --permanent --add-port=10258/tcp
firewall-cmd --permanent --add-port=10259/tcp
firewall-cmd --permanent --add-port=10251/udp
firewall-cmd --permanent --add-port=10252/udp
firewall-cmd --permanent --add-port=10256/udp
firewall-cmd --permanent --add-port=10257/udp
firewall-cmd --permanent --add-port=10258/udp
firewall-cmd --permanent --add-port=10259/udp
firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd --permanent --add-port=6783/udp
firewall-cmd --permanent --add-port=6784/udp
# firewall-cmd --add-masquerade --permanent
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -j ACCEPT
firewall-cmd --reload
firewall-cmd --zone=public --list-all 