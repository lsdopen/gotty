FROM alpine:latest

LABEL org.opencontainers.image.authors="seagyn@lsdopen.io"
LABEL org.opencontainers.image.title="GoTTY Docker"
LABEL org.opencontainers.image.description="A Docker image for GoTTY."

# This is the version of Gotty we're running
ARG GOTTY_RELEASE=gotty_v1.3.0_linux_amd64.tar.gz

# Create non-root ruser
ARG USER=gotty
RUN adduser -D $USER
WORKDIR /home/$USER

# Add dependencies
RUN apk add --update go git curl

# Install GoTTY
RUN mkdir -p /tmp/gotty
RUN GOPATH=/tmp/gotty go get github.com/sorenisanerd/gotty
RUN mv /tmp/gotty/bin/gotty /usr/local/bin/

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/kubectl


# Clean up
RUN apk del go git curl
RUN rm -rf /tmp/gotty /var/cache/apk/*

USER $USER
