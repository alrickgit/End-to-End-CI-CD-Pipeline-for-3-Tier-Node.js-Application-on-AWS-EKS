#!/bin/bash
apt update -y
apt install docker.io -y
usermod -aG docker ubuntu
newgrp docker
docker run -d --restart=always --name sonar -p 9000:9000 sonarqube:lts-community