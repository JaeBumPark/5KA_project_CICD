#!/bin/bash
apt-get update -y
apt-get install -y openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCEF32E745F2C3D5
sudo apt-get -y update
sudo apt-get -y install jenkins
sed -i s/HTTP_PORT=8080/HTTP_PORT=7777/g /etc/default/jenkins
sed -i s/JENKINS_PORT=8080/JENKINS_PORT=7777/g /usr/lib/systemd/system/jenkins.service
systemctl daemon-reload
systemctl restart jenkins
systemctl enable jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
<<<<<<< HEAD
=======

>>>>>>> 984a0c74ef76f47646ae46af96043ad8152b2c1c
