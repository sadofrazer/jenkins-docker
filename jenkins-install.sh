#!/bin/bash
sudo yum install java-1.8.0-openjdk
java -version
sudo yum install -y vim && alias vi=vim
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/" >> ~/.bash_profile
echo "export JRE_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/jre" >> ~/.bash_profile
source ~/.bash_profile
echo $JAVA_HOME
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo yum -y install epel-release
sudo yum -y install nginx