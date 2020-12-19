FROM quay.io/spivegin/tlmbasedebian:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y &&\
    apt-get install pdns-server postgresql-client-9.6 postgresql-client dbconfig-pgsql pdns-backend-pgsql pdns-backend-pgsql -y &&\
    # apt-get install pdns-server -y &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/powerdns/pdns.conf /etc/powerdns/
ADD files/powerdns/pdns.local.gpgsql.conf /etc/powerdns/pdns.d/
CMD ["pdns_server","--daemon=no","--guardian=no","--loglevel=9"]