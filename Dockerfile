FROM docker/sandbox-templates:shell

# -- System packages for native npm modules (as root) --
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# -- pi.dev coding agent (as agent user) --
USER agent
RUN npm install -g @mariozechner/pi-coding-agent

# Disable telemetry inside sandbox
ENV PI_TELEMETRY=0

# Verify installation
RUN node --version && pi --version
