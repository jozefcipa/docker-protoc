ARG prototool_version="1.8.0"
ARG protoc_version="3.11.2"

FROM golang:1.12-stretch AS base

# ARGs are resetted after each FROM statement, this uses default value, defined in global scope
# See https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG prototool_version
ARG protoc_version

# Basic configuration
RUN set -ex
RUN apt-get update && apt-get install -y curl unzip

RUN curl -sSL \
      "https://github.com/uber/prototool/releases/download/v${prototool_version}/prototool-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/prototool && \
      chmod +x /usr/local/bin/prototool
RUN curl -sSL \
      "https://github.com/google/protobuf/releases/download/v${protoc_version}/protoc-${protoc_version}-$(uname -s | tr 'A-Z' 'a-z')-$(uname -m).zip" \
      -o protoc.zip && \
      unzip protoc.zip -d protoc && \
      mv ./protoc/bin/* /usr/local/bin/ && \
      mv ./protoc/include/* /usr/local/include/ && \
      rm protoc.zip && rm -rf protoc

# ---------------------
# Protoc - GoLang
# ---------------------
FROM base as protoc-go

ARG prototool_version
ARG protoc_version

# Install Go GRPC generator library
RUN go get github.com/golang/protobuf/protoc-gen-go

COPY entrypoint-go.sh entrypoint.sh
WORKDIR build/
COPY prototool-go.yml prototool.yaml

ENTRYPOINT ["bash", "../entrypoint.sh"]

# ---------------------
# Protoc - NodeJS
# ---------------------
FROM base as protoc-nodejs

ARG prototool_version
ARG protoc_version
ARG nodejs_version="12.x"

# Install NodeJS
RUN curl -sSL "https://deb.nodesource.com/setup_${nodejs_version}" | bash - && apt-get install -y nodejs

# Set user
RUN mkdir /home/node && useradd node && chown -R "node:node" /home/node
WORKDIR /home/node

# Install NodeJS GRPC generator libraries
RUN npm install ts-protoc-gen grpc-tools

COPY entrypoint-nodejs.sh entrypoint.sh
WORKDIR build/
COPY prototool-nodejs.yml prototool.yaml

ENTRYPOINT ["bash", "../entrypoint.sh"]
