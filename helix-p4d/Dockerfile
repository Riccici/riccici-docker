# ----------------------------------------------------------------------------
#   Dockerfile for Perforce Helix Core Server
#   
#   this Dockerfile is based on Perforce's official Linux package-based installation
#   see https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.html
# ---------------------------------------------------------------------------- 

# note: not all versions of Ubuntu are supported by Perforce
# see https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.html#Prerequi
FROM ubuntu:jammy 

LABEL vendor="Riccici"
LABEL maintainer="Riccici (lqwork2023@gmail.com)"

# notice: in github actions, get warning "debconf: delaying package configuration, since apt-utils is not installed"
#         see https://github.com/phusion/baseimage-docker/issues/319
#         fix it by setting two environment variables below
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS="yes"

# Install prerequisites && add Perforce package repository
RUN \
    apt-get update && \
    apt-get install -y wget gnupg2 apt-utils


# Install Perforce package repository
# notice: in perforce's official document, perforce.pubkey save on /usr/share/keyrings/perforce.gpg
#         but in my case, it doesn't work in Dockerfile, save it on /etc/apt/trusted.gpg.d/perforce.gpg instead works well
RUN \
    wget -qO - https://package.perforce.com/perforce.pubkey | gpg --dearmor | tee /etc/apt/trusted.gpg.d/perforce.gpg > /dev/null && \
    echo "deb http://package.perforce.com/apt/ubuntu jammy release" > /etc/apt/sources.list.d/perforce.list && \
    apt-get update

# why this 5 packages? see https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html
RUN apt-get install -y helix-p4d helix-p4dctl helix-proxy helix-broker helix-cli

COPY scripts/init.sh /usr/local/bin/init.sh
COPY scripts/latest_checkpoint.sh /usr/local/bin/latest_checkpoint.sh
COPY scripts/restore.sh /usr/local/bin/restore.sh
COPY scripts/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/init.sh && \
    chmod +x /usr/local/bin/latest_checkpoint.sh && \
    chmod +x /usr/local/bin/restore.sh && \
    chmod +x /usr/local/bin/setup.sh


ENV P4HOME=/p4

ENV P4ROOT=$P4HOME/root \
    PRDEPOTS=$P4HOME/depot \
    P4CKP=$P4HOME/checkpoints

ARG NAME=helix-core-server
ARG P4NAME=master
ARG P4PORT=1666
ARG P4USER=admin
ARG P4PASSWD=qwer1234
ARG P4CHARSET=utf8


ENV NAME=$NAME \
    P4NAME=$P4NAME \
    P4PORT=$P4PORT \
    P4USER=$P4USER \
    P4PASSWD=$P4PASSWD \
    P4CHARSET=$P4CHARSET \
    JNL_PREFIX=$P4NAME

EXPOSE $P4PORT
VOLUME $P4HOME

ENTRYPOINT \
    init.sh && \
    /usr/bin/tail -f $P4ROOT/logs/log


HEALTHCHECK \
    --interval=2m \
    --timeout=10s \
    CMD p4 info -s > /dev/null || exit 1
