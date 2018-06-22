#!/bin/bash
ETCD_VERSION=v3.3.8

mkdir -p /var/lib/k8s/etcd/data
groupadd etcd
useradd etcd -d /var/lib/k8s/etcd -s /bin/false -g etcd
chown etcd:etcd /var/lib/k8s/etcd -R
wget -P /tmp/ https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
tar -xzf /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp/
chmod +x -R /tmp/etcd-${ETCD_VERSION}-linux-amd64
mv /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcd /usr/bin/etcd
mv /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/bin/etcdctl

cp etcd.conf.yml.example /var/lib/k8s/etcd/etcd.conf.yml.example
cp etcd.conf.yml.example /var/lib/k8s/etcd/etcd.conf.yml

cp etcd.service /lib/systemd/system/etcd.service

systemctl daemon-reload
systemctl enable etcd.service

#etcdctl set /coreos.com/network/config '{"Network": "100.100.0.0/16","SubnetLen": 24,"Backend": {"Type": "vxlan","VNI": 1}}'
#etcdctl get /coreos.com/network/config
#etcdctl rm  /coreos.com --recursive
