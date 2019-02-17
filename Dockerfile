FROM alpine:3.9

MAINTAINER Christian Glaeser <glaeser@denkformat.de>

ENV SDKMAN_DIR /usr/local/sdkman


ENV GRAILS_VERSION 2.5.6

#added packages to create a comparable images to docker debian stretch / dev base tools
RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add ca-certificates
RUN apk add curl
RUN apk add wget
RUN apk add git
RUN apk add bzr
RUN apk add mercurial
RUN apk add subversion
RUN apk add procps
RUN apk add unzip
RUN apk add zip
RUN apk add rsync
RUN apk add openjdk8

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"    


#check java installation
RUN echo 'public class Main { public static void main(String[] args) { System.out.println("Java code is running fine!"); } }' > Main.java && \
    javac Main.java && \
    java Main 
    
RUN apk add tree
RUN apk add sambaclient
# install sdkman
RUN curl -s "https://get.sdkman.io" | bash
#configure sdkman install
RUN source "$HOME/.sdkman/bin/sdkman-init.sh"
#check sdk installation
RUN sdk version
#install grails
RUN sdk install grails $GRAILS_VERSION


# Setup Grails path.
ENV GRAILS_HOME /root/.sdkman/candidates/grails/current
ENV GRAILS_OPTS '-server -Xmx4096M -Xms256M -Dfile.encoding=UTF-8'
ENV PATH $GRAILS_HOME/bin:$PATH


# Set Default Behavior
#ENTRYPOINT ["grails"]