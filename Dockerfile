FROM golang:1.12-stretch AS base

ARG prototool_version="1.8.0"
ARG protoc_version="3.11.2"

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

# Install documentation plugin
RUN go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

# ---------------------
# Protoc - GoLang
# ---------------------
FROM base as protoc-go

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
