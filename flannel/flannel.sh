#!/bin/bash
FLANNEL_VERSION=v0.10.0

mkdir -p /var/lib/k8s/flannel
wget -P /tmp/ https://github.com/coreos/flannel/releases/download/${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz
tar -xzf /tmp/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz -C /tmp/
chmod +x /tmp/flanneld
chmod +x /tmp/mk-docker-opts.sh
mv /tmp/flanneld /usr/bin/flanneld
mv /tmp/mk-docker-opts.sh /var/lib/k8s/flannel/mk-docker-opts.sh

cp flanneld.conf /var/lib/k8s/flannel/flanneld.conf
cp flanneld.service /lib/systemd/system/flanneld.service

mkdir -p /lib/systemd/system/docker.service.d
cp docker-flannel.conf /lib/systemd/system/docker.service.d/docker-flannel.conf

systemctl daemon-reload
systemctl enable flanneld.service
