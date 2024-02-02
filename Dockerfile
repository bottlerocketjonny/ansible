FROM linuxmintd/mint21.2-amd64 AS base

WORKDIR /usr/local/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS jonny

ARG TAGS

RUN addgroup --gid 1000 jonny && \
    adduser --gecos jonny --uid 1000 --gid 1000 --disabled-password jonny && \
    mkdir -p /home/jonny/.ssh && \
    chmod 700 /home/jonny/.ssh

RUN echo "jonny ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jonny

USER jonny
WORKDIR /home/jonny

COPY --chown=jonny:jonny . .

ENV USER=jonny


CMD ["sh", "-c", "ansible-playbook -vvv $TAGS --ask-vault-pass local.yml"]
