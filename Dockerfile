FROM debian:trixie-slim


RUN apt-get update && \
    apt-get install -y  curl wget  \
    nano lldpd tini htop iputils-ping traceroute net-tools \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
    apt-get install -y frr frr-pythontools && \
    rm -rf /var/lib/apt/lists/*

# Own the config / PID files
RUN mkdir -p /var/run/frr
RUN chown -R frr:frr /etc/frr /var/run/frr

# Simple init manager for reaping processes and forwarding signals
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default CMD starts watchfrr
COPY --chmod=0755 docker-start /usr/lib/frr/docker-start
CMD ["/usr/lib/frr/docker-start"]
