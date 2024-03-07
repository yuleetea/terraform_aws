#! /bin/bash
# needs to copy pasted exactly like this, for some reason the wget needs to be entered this exact way

sudo yum update -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum upgrade

sudo yum install java-17-amazon-corretto-headless -y

sudo yum install jenkins -y

sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo amazon-linux-extras install docker -y

sudo service docker start

# need to add group for docker to go around permission, the ec2-user would be changed depending on your flavor ami

sudo groupadd docker

sudo usermod -a -G docker ec2-user

newgrp docker

sudo docker pull yuleetea/python-flask

# install pip and flask dependancies

# #Install the Python developer package to get the headers and libraries required to compile extensions and install pip:
# sudo yum install python3-devel -y

# sudo curl -O https://bootstrap.pypa.io/get-pip.py

# sudo yum install pip3

# pip3 install Flask