FROM centos:7
LABEL Name="Frazer SADO"
LABEL email="sadofrazer@yahoo.fr"
#Install Dependencies
RUN yum update -y && yum install -y git curl java java-devel unzip which && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash && yum install -y git-lfs && yum clean all
# Install heroku cli
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
    && yum -y install nodejs \
    && npm install -g heroku
# install docker
RUN curl -fsSL https://get.docker.com/ | sh
RUN mkdir /jenkins
COPY . /jenkins
RUN sh /jenkins/jenkins-install.sh
RUN cp /jenkins/jenkins.conf /etc/nginx/conf.d/jenkins.conf
VOLUME /var/lib/jenkins
RUN systemctl start nginx
RUN systemctl enable nginx
EXPOSE 80
EXPOSE 8080
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]