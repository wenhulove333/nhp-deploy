FROM golang:1.24 AS builder
WORKDIR /src
RUN git clone https://github.com/wenhulove333/opennhp.git
# RUN git clone https://github.com/OpenNHP/opennhp.git
WORKDIR /src/opennhp
RUN git checkout ztdo
RUN make

FROM debian AS nhp-server
WORKDIR /app
COPY --from=builder /src/opennhp/release/nhp-server .
CMD ["/bin/bash", "-c", "tail -f /dev/null"]


FROM debian AS nhp-agent
WORKDIR /app
COPY --from=builder /src/opennhp/release/nhp-agent .
COPY --from=builder /src/opennhp/release/nhp-de ./nhp-de
CMD ["/bin/bash", "-c", "tail -f /dev/null"]

FROM debian AS nhp-db
WORKDIR /app
# COPY --from=builder /src/opennhp/release/nhp-db .
COPY --from=builder /src/opennhp/release/nhp-de .
COPY meta.json .
COPY policyinfo.json .
COPY sample.txt .

CMD ["/bin/bash", "-c", "tail -f /dev/null"]
