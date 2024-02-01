FROM ubuntu:latest

EXPOSE 21416

VOLUME /var/lib/boinc-client

ADD https://github.com/BOINC/boinc.git boinc
#COPY boinc boinc

RUN apt update; apt upgrade -y; apt install -y unattended-upgrades \
      autoconf make clang libtool pkg-config \
      openssl libssl-dev curl libcurl4-openssl-dev zlib1g zlib1g-dev; \
    cd boinc; ./_autosetup; ./configure --enable-client --disable-manager --disable-server; make; cd ..; \
    mkdir /var/lib/boinc-client; mv boinc/client/boinc_client /usr/bin/; rm -rf boinc; \
    apt purge -y autoconf make clang libtool pkg-config \
       openssl libssl-dev curl libcurl4-openssl-dev zlib1g zlib1g-dev; \
    apt autoremove; apt clean; rm -rf /tmp/*

ENTRYPOINT [ "/usr/bin/boinc_client", "--dir", "/var/lib/boinc-client", \
   "--allow_remote_gui_rpc", "--gui_rpc_port", "31416" ]
