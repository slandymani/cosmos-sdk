FROM golang:1.18-buster AS build-env

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/cosmos-sdk

# Add source files
COPY . .

# install simapp, remove packages
RUN make cosmovisor

# Install ca-certificates
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates

# Copy over binaries from the build-env
COPY cosmovisor/cosmovisor /usr/bin/cosmovisor

WORKDIR /root

EXPOSE 26656 26657 1317 9090

# Run simd by default, omit entrypoint to ease using container with simcli
CMD ["cosmovisor"]
