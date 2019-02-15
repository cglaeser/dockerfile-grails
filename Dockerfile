FROM ubuntu:18.04

MAINTAINER Christian Glaeser <glaeser@denkformat.de>

SHELL ["/bin/bash","-c"]

ENV GRAILS_VERSION 2.5.6

RUN apt-get update -qq && apt-get upgrade && apt-get install -y -qq unzip && apt-get install zip && apt-get install -y -qq locales && apt-get install -y -qq rsync
# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
	
# Fix certificate issues, found as of 
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN apt-get install -y -qq tree
RUN apt-get install -y -qq smbclient
RUN dpkg-reconfigure -f noninteractive tzdata && \
        sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="de_DE.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=de_DE.UTF-8
RUN curl -sSL https://get.sdkman.io | bash
RUN echo sdkman_auto_answer=true > /root/.sdkman/etc/config
RUN source /root/.sdkman/bin/sdkman-init.sh
RUN RUN yes | /bin/bash -l -c 'sdk install grails $GRAILS_VERSION'


# Setup Grails path.
ENV GRAILS_HOME /root/.sdkman/candidates/grails/current
ENV GRAILS_OPTS '-server -Xmx4096M -Xms256M -Dfile.encoding=UTF-8'
ENV PATH $GRAILS_HOME/bin:$PATH


# Set Default Behavior
#ENTRYPOINT ["grails"]