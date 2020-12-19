FROM quay.io/spivegin/tlmbasedebian:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /usr/share/man/man1/ &&\
    mkdir -p /usr/share/man/man7/
RUN apt-get update && apt-get upgrade -y &&\
    apt-get install pdns-server -y &&\
    apt-get install pdns-backend-pgsql -y | no &&\
    # apt-get install pdns-server -y &&\
    dpkg --configure -a &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/powerdns/pdns.conf /etc/powerdns/
ADD files/powerdns/pdns.local.gpgsql.conf /etc/powerdns/pdns.d/
CMD ["pdns_server","--daemon=no","--guardian=no","--loglevel=9"]