FROM ubuntu:latest

ENV BOINC_VERSION=client_release/7.24/7.24.3

EXPOSE 31416

VOLUME /var/lib/boinc-client

RUN apt update; apt upgrade -y; apt install -y unattended-upgrades; \
    apt install -y git autoconf make clang libtool pkg-config \
      openssl libssl-dev curl libcurl4-openssl-dev zlib1g zlib1g-dev; \
    git clone --branch "${BOINC_VERSION}" https://github.com/BOINC/boinc.git; \
    cd boinc; ./_autosetup; ./configure --enable-client --disable-manager --disable-server; make; cd ..; \
    mv boinc/client/boinc_client /usr/bin/; mkdir /var/lib/boinc-client; rm -rf boinc; \
    apt purge -y git autoconf make clang libtool pkg-config \
      openssl libssl-dev curl libcurl4-openssl-dev zlib1g zlib1g-dev; \
    apt autoremove; apt clean; rm -rf /tmp/*

ENTRYPOINT [ "/usr/bin/boinc_client", "--dir", "/var/lib/boinc-client", \
  "--allow_remote_gui_rpc", "--gui_rpc_port", "31416" ]
