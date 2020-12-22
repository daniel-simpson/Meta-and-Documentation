FROM ubuntu:16.04

RUN apt-get update

RUN \
  apt-get install -y \
  # Tooling
  git wget curl gcc make \
  # PowerShell Prerequisites
  libunwind8 libicu55 \
  # GraphViz
  graphviz

# Download PowerShell
RUN \
  wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb

# TODO add to prereqs
RUN apt-get install -y apt-transport-https software-properties-common

# Install NodeJS + meta
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y nodejs \
  && npm i -g meta

# Update after dpkg and Install PowerShell
RUN apt-get update \
  && apt-get install -y apt-utils powershell

# Install Golang
ENV GOVERSION 1.12
ENV GOROOT /opt/go
ENV GOPATH /root/.go
RUN cd /opt \
  && wget -q https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
  && tar zxf go${GOVERSION}.linux-amd64.tar.gz \
  && rm go${GOVERSION}.linux-amd64.tar.gz \
  && ln -s /opt/go/bin/go /usr/bin/ \
  && mkdir $GOPATH \
  && export PATH=$PATH:/usr/bin/go

RUN go get -v github.com/kovetskiy/mark

RUN pwsh -v
RUN node -v
RUN npm -v
RUN meta -V
RUN go version

ENTRYPOINT [ "pwsh" ]

