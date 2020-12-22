FROM ubuntu:16.04

ENV GOVERSION 1.12
ENV GOROOT /opt/go
ENV GOPATH /root/.go

RUN apt-get update \
  #
  # Setup
  && apt-get install -y \
    # Tooling
    git wget curl gcc make apt-transport-https software-properties-common \
    # PowerShell Prerequisites
    apt-utils libunwind8 libicu55 \
    # GraphViz
    graphviz \
  #
  # Download PowerShell
  && wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  #
  # Install NodeJS + meta
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y nodejs \
  #
  # Update packages
  && apt-get update \
  #
  # Install PowerShell
  && apt-get install -y powershell \
  #
  # Install Meta
  && npm install -g meta \
  #
  # Install Golang
  && cd /opt \
  && wget -q https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
  && tar zxf go${GOVERSION}.linux-amd64.tar.gz \
  && rm go${GOVERSION}.linux-amd64.tar.gz \
  && ln -s /opt/go/bin/go /usr/bin/ \
  && mkdir $GOPATH \
  && export PATH=$PATH:/usr/bin/go \
  #
  # Install mark
  && go get -v github.com/kovetskiy/mark

ENTRYPOINT [ "pwsh" ]

