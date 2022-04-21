FROM ubuntu:18.04

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y bzip2 kmod libstdc++5:i386 libpam0g:i386 libx11-6:i386 expect iptables net-tools iputils-ping iproute2
RUN apt-get install -y wget

RUN wget https://portal.gpc.telekom-dienste.de/SNX/INSTALL/snx_install.sh \
  && chmod +x snx_install.sh \
  && ./snx_install.sh

RUN uname -a 
RUN apt-get -y install python3-pip git
RUN python3 -m pip install git+https://github.com/michel-kraemer/snxvpn.git 

ADD entrypoint.sh /
ADD root.db /etc/snx/root.db

ENTRYPOINT /entrypoint.sh
