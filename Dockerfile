FROM docker/sandbox-templates:shell

# -- System packages for native npm modules (as root) --
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential fd-find \
    && rm -rf /var/lib/apt/lists/*

# -- pi.dev coding agent (as agent user) --
USER agent
RUN npm install -g @mariozechner/pi-coding-agent

# Pre-install fd where pi expects it
RUN mkdir -p ~/.pi/agent/bin && ln -s /usr/bin/fdfind ~/.pi/agent/bin/fd

# Disable telemetry inside sandbox
ENV PI_TELEMETRY=0

# Verify installation
RUN node --version && pi --version

# NOTE: The sandbox runtime wipes custom files and overrides ENTRYPOINT/CMD.
# To auto-launch pi, build this image, start a sandbox from it, then:
#
#   1. Inside the sandbox:
#      echo '[ -t 0 ] && [ -z "$PI_LAUNCHED" ] && export PI_LAUNCHED=1 && exec pi' \
#        | sudo tee -a /etc/sandbox-persistent.sh
#
#   2. From the host:
#      sbx template save shell-pi-sandbox pi-sandbox:v2
#
#   3. Run with auto-launch:
#      sbx run -t pi-sandbox:v2 shell
