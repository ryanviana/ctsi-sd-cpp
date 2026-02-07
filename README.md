# ctsi-sd-cpp

![C++](https://img.shields.io/badge/C%2B%2B-00599C?style=flat&logo=c%2B%2B&logoColor=white)
![Cartesi](https://img.shields.io/badge/Cartesi-000000?style=flat&logo=cartesi&logoColor=white)

Stable Diffusion image generation running inside [Cartesi Rollups](https://docs.cartesi.io/), powered by [stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp). This variant builds the SD inference engine from source during Docker build time, targeting RISC-V 64-bit.

> **Note:** This repo is a companion to [cartesi-stable-diffusion](https://github.com/ryanviana/cartesi-stable-diffusion). It focuses on compiling `stable-diffusion.cpp` from source rather than using pre-built binaries. The repo is currently incomplete -- it references `dapp.cpp` and a `Makefile` that live in the sibling repo.

## Tech Stack

- **C++** with CMake and Ninja build system
- **stable-diffusion.cpp** -- lightweight C++ SD inference
- **OpenBLAS** for optimized linear algebra
- **Docker** multi-stage build on `riscv64/ubuntu:22.04`
- **Cartesi Rollups SDK 0.6.0**

## Project Structure

```
Dockerfile   # Multi-stage RISC-V build (builder + runtime)
setup.sh     # Downloads Stable Diffusion v1.4 model from HuggingFace
models/      # Model weights directory (created by setup.sh)
```

## Setup

### 1. Download the model

```bash
./setup.sh
```

This downloads the Stable Diffusion v1.4 checkpoint (~4 GB) from HuggingFace into `./models/`.

### 2. Build the Cartesi DApp

```bash
cartesi build
```

### 3. Run

```bash
cartesi run
```
