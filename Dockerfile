# Dockerfile for FRR (Free Range Routing) based on Debian
FROM debian:trixie-slim

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive


# Install required dependencies and FRR
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    frr \
    frr-pythontools \
    lldpd \
    iproute2 \
    iputils-ping \
    traceroute\
    net-tools \
    curl \
    wget \
    vim-tiny \
    htop\
    nano\
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /etc/frr /var/log/frr /var/run/frr && \
    chown -R frr:frr /etc/frr /var/log/frr /var/run/frr

# Copy FRR configuration template
COPY daemons /etc/frr/daemons

# # Set permissions for FRR configuration
RUN chmod 640 /etc/frr/daemons && \
    chown frr:frr /etc/frr/daemons

# Enable FRR daemons by default
# You can customize this by modifying the daemons file

# Expose common routing protocol ports
EXPOSE 179 2604 2605 2606 2607 2608 2609 2610 2611 2612 2613 2614 2615

# Create startup script
COPY start-frr.sh /usr/local/bin/start-frr.sh
RUN chmod +x /usr/local/bin/start-frr.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/start-frr.sh"]

# Default command
CMD ["frr", "start"]
