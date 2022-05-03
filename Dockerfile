FROM golang:1.18-alpine AS build-env

# Install minimum necessary dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/cosmos-sdk

# Add source files
COPY . .

# install simapp, remove packages
RUN make cosmovisor


# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/src/github.com/cosmos/cosmos-sdk/cosmovisor/cosmovisor /usr/bin/cosmovisor

EXPOSE 26656 26657 1317 9090

# Run simd by default, omit entrypoint to ease using container with simcli
CMD ["cosmovisor"]
