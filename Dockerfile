FROM resin/rpi-raspbian:stretch
ENV VERSION v4.27-9668-beta-2018.05.29

#RUN [ "cross-build-start"] 

RUN apt-get update  && apt-get upgrade

WORKDIR /usr/local/vpnserver

RUN apt-get update &&\
        apt-get -y -q install iptables vim isc-dhcp-relay net-tools tcpdump iputils-ping gcc make curl build-essential && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/*
RUN curl -sL http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/32bit_-_ARM_EABI/softether-vpnserver-${VERSION}-linux-arm_eabi-32bit.tar.gz | \
        tar zxv -C /usr/local/ &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make
ADD runner.sh /usr/local/vpnserver/runner.sh
RUN chmod 755 /usr/local/vpnserver/runner.sh

EXPOSE 991/tcp 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
ENTRYPOINT ["/usr/local/vpnserver/runner.sh"]

#RUN [ "cross-build-end" ]

