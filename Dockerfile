FROM golang:1.24 AS builder
WORKDIR /src
# RUN git clone https://github.com/wenhulove333/opennhp.git
RUN git clone https://github.com/OpenNHP/opennhp.git
WORKDIR /src/opennhp
# RUN git checkout dhp-crypto
RUN make

FROM wenhulove333/debian-network:1.0 AS nhp-server
WORKDIR /app
COPY --from=builder /src/opennhp/release/nhp-server .
CMD ["/bin/bash", "-c", "tail -f /dev/null"]


FROM wenhulove333/debian-network:1.0 AS nhp-agent
WORKDIR /app
COPY --from=builder /src/opennhp/release/nhp-agent .
CMD ["/bin/bash", "-c", "tail -f /dev/null"]

FROM wenhulove333/debian-network:1.0 AS nhp-db
WORKDIR /app
# COPY --from=builder /src/opennhp/release/nhp-db .
COPY --from=builder /src/opennhp/release/nhp-de .
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
