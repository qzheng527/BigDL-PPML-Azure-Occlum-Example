FROM occlum/occlum:0.27.3-ubuntu20.04 as ppml

ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
ARG HTTPS_PROXY_HOST
ARG HTTPS_PROXY_PORT
ENV HTTP_PROXY=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT
ENV HTTPS_PROXY=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT

RUN mkdir -p /opt/src && \
    cd /opt/src && \
    git clone https://github.com/qzheng527/occlum.git && \
    cd occlum && \
    git checkout maa_init && \
    apt purge libsgx-dcap-default-qpl -y

RUN echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    apt update && \
    apt install az-dcap-client

RUN cd /opt/src/occlum && \
    git submodule update --init && \
    cd demos/remote_attestation/azure_attestation/maa_init && \
    ./build.sh