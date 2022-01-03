FROM golang:1.16.6-buster
RUN apt-get update
RUN apt-get install -y upx sudo unzip gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev build-essential bison flex libssl-dev bc

# Copy Source Files
RUN mkdir /GoRAT
WORKDIR /GoRAT
COPY . .

# Build Payload
RUN go mod download -x
RUN go get mvdan.cc/garble@v0.3.0
RUN ./build_payload.sh -a
