FROM python:3.7-alpine
COPY . .

# ------------------------
# SSH Server support
# ------------------------
ENV SSH_PASSWD "root:Docker!"
RUN apk --update add openssl-dev \
    openssh \
    openrc \
    bash \
    && echo "$SSH_PASSWD" | chpasswd 

RUN pip install -r requirements.txt
RUN chmod 755 init_container.sh 
COPY sshd_config /etc/ssh/

EXPOSE 2222 5000
ENV PORT 5000
ENTRYPOINT ["/init_container.sh"]
