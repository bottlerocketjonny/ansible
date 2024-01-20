FROM ubuntu:latest AS base

WORKDIR /usr/local/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS jonny

ARG TAGS

RUN addgroup --gid 1000 jonny
RUN adduser --gecos jonny --uid 1000 --gid 1000 --disabled-password jonny

USER jonny

WORKDIR /home/jonny

FROM jonny

CMD ["sh", "-c", "ansible-pull -U https://github.com/bottlerocketjonny/ansible.git"]

