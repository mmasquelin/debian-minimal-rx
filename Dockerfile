FROM debian:buster
MAINTAINER Mickael Masquelin <mickael.masquelin@univ-lille.fr>

# Remove dialog steps
ENV DEBIAN_FRONTEND noninteractive

# Install base packages and slim down image
RUN echo " ---> Installation de quelques outils supplementaires..." && \
    apt-get -y update && \
    apt-get install --fix-missing && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    curl vim net-tools telnet wget python git openssh-server sshpass \
    nghttp2 netcat-openbsd tcpdump traceroute mtr bind9-host apache2 \
    dnsutils vnstat iftop nload nethogs bmon iptraf cbm iperf3

RUN echo " ---> Nettoyage après installation..."
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/??

# Configure sshd service
RUN echo " ---> Configuration du service ssh..."
RUN mkdir /var/run/sshd
RUN echo 'root:ansible' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Correction d'un problème avec sshd qui éjecte l'utilisateur après s'être connecté proprement
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Allow incoming connections
EXPOSE 8443 8080 22

# Start sshd service
CMD [ "/usr/sbin/sshd", "-D" ]
