FROM alpine:3.9

MAINTAINER Christian Glaeser <glaeser@denkformat.de>

ENV SDKMAN_DIR=/root/.sdkman


ENV GRAILS_VERSION 2.5.6

#added packages to create a comparable images to docker debian stretch / dev base tools
RUN apk update
RUN apk upgrade
RUN apk add bash

#now safe to assume bash exists and run further commands in bash
SHELL ["/bin/bash","-c"]

RUN apk add ca-certificates
RUN apk add curl
RUN apk add wget
RUN apk add git
RUN apk add bzr
RUN apk add procps
RUN apk add unzip
RUN apk add zip
RUN apk add rsync
RUN apk add findutils
RUN apk add alpine-sdk
RUN apk add openssh-client
RUN apk add openjdk8

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"    


#check java installation
RUN echo 'public class Main { public static void main(String[] args) { System.out.println("Java code is running fine!"); } }' > Main.java && \
    javac Main.java && \
    java Main 
    
RUN apk add tree
RUN apk add samba-client
# install sdkman
RUN curl -s "https://get.sdkman.io" | bash
#configure sdkman install
RUN echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config && \
    echo "sdkman_insecure_ssl=true" >> $SDKMAN_DIR/etc/config
#check sdk installation
RUN . /root/.sdkman/bin/sdkman-init.sh && sdk version
#install grails
RUN . /root/.sdkman/bin/sdkman-init.sh && sdk install grails $GRAILS_VERSION


# Setup Grails path.
ENV GRAILS_HOME /root/.sdkman/candidates/grails/current
ENV GRAILS_OPTS '-server -Xmx4096M -Xms512M -Dfile.encoding=UTF-8'
ENV PATH $GRAILS_HOME/bin:$PATH

# check successful grails setup
RUN grails help

# Set Default Behavior
#ENTRYPOINT ["grails"]