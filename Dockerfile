FROM openjdk:8

MAINTAINER Christian Glaeser <glaeser@denkformat.de>

SHELL ["/bin/bash","-c"]

ENV GRAILS_VERSION 2.5.6

RUN apt-get update -qq && apt-get install -y -qq unzip && apt-get install zip && apt-get install -y -qq locales && apt-get install -y -qq rsync
RUN apt-get install -y - qq tree
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