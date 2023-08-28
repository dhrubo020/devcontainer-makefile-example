FROM ubuntu:latest

# Install required tools
RUN apt-get update && \
    apt-get install -y build-essential make sudo curl wget unzip git apt-transport-https ca-certificates gnupg

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install -y google-cloud-sdk
