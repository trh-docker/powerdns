FROM quay.io/spivegin/tlmbasedebian:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /usr/share/man/man1/ &&\
    mkdir -p /usr/share/man/man7/
ADD files/powerdns/pbns /etc/apt/preferences.d/
RUN echo deb [arch=amd64] http://repo.powerdns.com/debian stretch-rec-44 main > /etc/apt/sources.list.d/pdns.list 

RUN apt-get update && apt-get upgrade -y &&\
    apt-get install gnupg2 curl -y &&\
    curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
WORKDIR /root/
ADD https://repo.powerdns.com/debian/pool/main/p/pdns/pdns-server_4.4.0-1pdns.stretch_amd64.deb /root/
ADD https://repo.powerdns.com/debian/pool/main/p/pdns/pdns-backend-pgsql-dbgsym_4.4.0-1pdns.stretch_amd64.deb /root/
RUN apt-get update && apt-get upgrade -y &&\
    apt-get install libluajit-5.1-2 libsodium18 libboost-program-options1.62.0 -y &&\
    dpkg -i pdns-server_4.4.0-1pdns.stretch_amd64.deb &&\
    dpkg -i pdns-backend-pgsql-dbgsym_4.4.0-1pdns.stretch_amd64.deb &&\
    # apt-get install pdns-server -y &&\
    # apt-get install pdns-backend-pgsql -y &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/powerdns/pdns.conf /etc/powerdns/
ADD files/powerdns/pdns.local.gpgsql.conf /etc/powerdns/pdns.d/
CMD ["pdns_server","--daemon=no","--guardian=no","--loglevel=9"]