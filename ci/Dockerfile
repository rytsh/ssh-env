FROM alpine:3

##################
# SSH in Docker
##################
LABEL maintainer="eray@devusage.com"

RUN apk add --no-cache \
    openssh

RUN echo "root:root1234" | chpasswd && \
    echo -e "PermitRootLogin yes\nBanner /etc/issue.net" >> /etc/ssh/sshd_config && \
    echo $'\
 _______  _______  __   __         _______  __    _  __   __ \n\
|       ||       ||  | |  |       |       ||  |  | ||  | |  |\n\
|  _____||  _____||  |_|  | ____  |    ___||   |_| ||  |_|  |\n\
| |_____ | |_____ |       ||____| |   |___ |       ||       |\n\
|_____  ||_____  ||       |       |    ___||  _    ||       |\n\
 _____| | _____| ||   _   |       |   |___ | | |   | |     | \n\
|_______||_______||__| |__|       |_______||_|  |__|  |___|  \n'\
    > /etc/issue.net && \
    echo 'Welcome to container land' > /etc/motd

EXPOSE 22

ENTRYPOINT ["/bin/sh"]

CMD ["-c", "ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && /usr/sbin/sshd -D"]