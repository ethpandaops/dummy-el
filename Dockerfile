FROM rust:1.83-bookworm AS builder
RUN apt-get update && apt-get -y upgrade && apt-get install -y cmake clang libclang-dev
WORKDIR /build
COPY . .
RUN cargo build --release

FROM ubuntu:24.04
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/release/dummy_el /usr/local/bin/dummy_el
ENTRYPOINT ["/usr/local/bin/dummy_el"]
