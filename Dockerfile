FROM cloudron/base:0.8.1
MAINTAINER SOGo developers <support@cloudron.io>

EXPOSE 3000

RUN mkdir -p /app/code
WORKDIR /app/code

RUN apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN echo "deb https://packages.inverse.ca/SOGo/nightly/3/ubuntu/ trusty trusty" >> "/etc/apt/sources.list"


RUN apt-get update && apt-get install -y sogo memcached

ADD sogo.conf nginx.conf start.sh /app/code/

RUN rm /etc/sogo/sogo.conf && ln -s /run/sogo.conf /etc/sogo/sogo.conf
RUN rm -rf /var/log/nginx && mkdir /run/nginx && ln -s /run/nginx /var/log/nginx
RUN mkdir /run/GNUstep && ln -s /run/GNUstep /home/cloudron/GNUstep

RUN chown -R cloudron:cloudron /etc/sogo

CMD [ "/app/code/start.sh" ]
