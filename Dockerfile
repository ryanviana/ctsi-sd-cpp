# syntax=docker.io/docker/dockerfile:1
FROM --platform=linux/riscv64 riscv64/ubuntu:22.04 as builder

ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  curl \
  libtool \
  wget \
  git \
  cmake \
  libopenblas-dev \
  ninja-build
rm -rf /var/lib/apt/lists/*
EOF

WORKDIR /opt/cartesi/dapp
COPY . .
RUN make

# Clone and build stable-diffusion.cpp
WORKDIR /opt/stable-diffusion
RUN git clone --recursive https://github.com/leejet/stable-diffusion.cpp . && \
  mkdir build && cd build && \
  cmake .. -G Ninja && \
  cmake --build . --config Release

FROM --platform=linux/riscv64 riscv64/ubuntu:22.04

ARG MACHINE_EMULATOR_TOOLS_VERSION=0.14.1
ADD https://github.com/cartesi/machine-emulator-tools/releases/download/v${MACHINE_EMULATOR_TOOLS_VERSION}/machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb /
RUN dpkg -i /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb \
  && rm /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb

LABEL io.cartesi.rollups.sdk_version=0.6.0
LABEL io.cartesi.rollups.ram_size=8000Mi

ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
  busybox-static=1:1.30.1-7ubuntu3
rm -rf /var/lib/apt/lists/* /var/log/* /var/cache/*
useradd --create-home --user-group dapp
EOF

ENV PATH="/opt/cartesi/bin:/opt/stable-diffusion/build/bin:${PATH}"

WORKDIR /opt/cartesi/dapp
COPY --from=builder /opt/cartesi/dapp/dapp .
COPY --from=builder /opt/stable-diffusion/build/bin/sd /opt/stable-diffusion/build/bin/sd

# Copy the models folder
COPY ./models /opt/stable-diffusion/models

ENV ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:5004"

ENTRYPOINT ["rollup-init"]
CMD ["/opt/cartesi/dapp/dapp"]

# Example usage for stable-diffusion.cpp
# CMD ["/opt/stable-diffusion/build/bin/sd", "-m", "/path/to/models/sd-v1-4.ckpt", "-p", "a lovely cat"]
