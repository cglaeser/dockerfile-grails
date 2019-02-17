FROM ubuntu:18.04

MAINTAINER Christian Glaeser <glaeser@denkformat.de>

SHELL ["/bin/bash","-c"]

ENV SDKMAN_DIR /usr/local/sdkman

ENV GRAILS_VERSION 2.5.6

RUN apt-get update && apt-get -y -qq upgrade
#added packages from stretch:curl
RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
	&& rm -rf /var/lib/apt/lists/*
#added packages from stretch:scm
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
		\
		procps \
	&& rm -rf /var/lib/apt/lists/*
# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update &&  \
    apt-get install -y -qq unzip && \
    apt-get install -y -qq zip && \
    apt-get install -y -qq locales && \
    apt-get install -y -qq rsync
#install jdk 8
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
RUN apt-get update && apt-get install -y -qq tree
RUN  apt-get update && apt-get install -y -qq smbclient
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN curl -sSL https://get.sdkman.io | bash
RUN source "/usr/local/sdkman/bin/sdkman-init.sh"
RUN sdk info 
#RUN chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
#RUN source "$HOME/.sdkman/bin/sdkman-init.sh" 
RUN 'sdk install grails $GRAILS_VERSION'


# Setup Grails path.
ENV GRAILS_HOME /root/.sdkman/candidates/grails/current
ENV GRAILS_OPTS '-server -Xmx4096M -Xms256M -Dfile.encoding=UTF-8'
ENV PATH $GRAILS_HOME/bin:$PATH


# Set Default Behavior
#ENTRYPOINT ["grails"]