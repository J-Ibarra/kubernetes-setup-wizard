#!/bin/bash

apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get -y update

apt-get -y install docker-ce

docker run --rm hello-world

systemctl stop docker
ip link delete docker0

sed 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ $DOCKER_NETWORK_OPTIONS \r\nExecStartPost=\/sbin\/iptables -P FORWARD ACCEPT/g' /lib/systemd/system/docker.service

systemctl daemon-reload
gpasswd -a docker

