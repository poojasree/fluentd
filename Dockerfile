FROM ubuntu:latest
USER root
RUN apt-get update
RUN apt-get install apache2 -y
COPY index.html /var/www/html/
#CMD [“/usr/sbin/apachectl”, “-D”, “FOREGROUND”]
RUN apt-get update
RUN apt-get install curl -y
RUN curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent2.5.sh > install-ubuntu-bionic-td-agent2.5.sh
RUN apt-get install gnupg -y
RUN curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add -
RUN sed -i 's/sudo//' install-ubuntu-bionic-td-agent2.5.sh
RUN sh install-ubuntu-bionic-td-agent2.5.sh
RUN apt-get update
#RUN apt-get install libc6
RUN apt-get install libc6-dev libc6-dbg -y
RUN apt-get upgrade -y 
RUN apt-get install gcc -y
RUN apt-get install make -y
RUN /usr/sbin/td-agent-gem install fluentd
RUN /usr/sbin/td-agent-gem install fluent-plugin-grep
RUN /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
RUN apt-get update
#RUN apt-get install vim -y
#RUN vim /opt/td-agent/embedded/lib/ruby/gems/2.5.0/extensions/x86
ADD td-agent.conf /etc/td-agent
#RUN /usr/sbin/td-agent -d /var/run/td-agent/td-agent.pid
RUN chmod 777 /var/log/apache2/access.log
#RUN chown td-agent:www-data /var/log/apache2/access.log
RUN service apache2 restart
RUN /usr/sbin/apache2 &
EXPOSE 80
CMD /usr/sbin/td-agent  
