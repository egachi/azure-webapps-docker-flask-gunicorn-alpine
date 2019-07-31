FROM python:3.7-alpine
RUN mkdir /code
COPY . /code
WORKDIR /code

# ------------------------
# SSH Server support
# Alpine Reference: https://wiki.alpinelinux.org/wiki/Setting_up_a_ssh-server
# ------------------------
ENV SSH_PASSWD "root:Docker!"
RUN apk --update --no-cache  add openssh \
    openrc \
    bash \ 
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && echo "$SSH_PASSWD" | chpasswd \
    && rm -rf /tmp/* /var/cache/apk/*

RUN pip install -r requirements.txt
RUN chmod 755 init_container.sh 
COPY sshd_config /etc/ssh/
RUN rc-update add sshd

EXPOSE 2222 5000
ENV PORT 5000
ENTRYPOINT ["/code/init_container.sh"]
