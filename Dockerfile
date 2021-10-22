FROM centos:centos7.9.2009
LABEL Name="Frazer SADO"
LABEL email="sadofrazer@yahoo.fr"
#Install Dependencies
RUN yum update -y && yum install -y git initscripts curl java java-devel unzip which && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash && yum install -y git-lfs && yum clean all
# Install heroku cli
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
    && yum -y install nodejs \
    && npm install -g heroku
#install docker
RUN curl -fsSL https://get.docker.com/ | sh

ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ “/sys/fs/cgroup” ]

RUN mkdir /jenkins
COPY . /jenkins
RUN sh /jenkins/jenkins-install.sh
RUN cp /jenkins/jenkins.conf /etc/nginx/conf.d/jenkins.conf
EXPOSE 80
EXPOSE 8080

#Copy Script files
COPY start-jenkins.sh /usr/local/jenkins/start-jenkins.sh
COPY start-jenkins.sh /usr/local/jenkins/start-jenkins.sh
COPY stop-jenkins.sh /usr/local/jenkins/stop-jenkins.sh
COPY jenkins /etc/init.d/jenkins
COPY sysconfig /etc/sysconfig/jenkins

VOLUME /var/lib/jenkins
VOLUME /usr/local/jenkins 
RUN cd /usr/local/jenkins
RUN wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
RUN chmod a+x /usr/local/jenkins/start-jenkins.sh && \
chmod a+x /usr/local/jenkins/stop-jenkins.sh &&\
chmod a+x /etc/init.d/jenkins

RUN sh /usr/local/jenkins/start-jenkins.sh
RUN systemctl enable nginx.service

CMD ["/usr/sbin/init"]