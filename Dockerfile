FROM docker/sandbox-templates:shell

# System packages: build-essential for native npm modules, fd-find for pi's file search
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential fd-find \
    && rm -rf /var/lib/apt/lists/*

# Install pi.dev coding agent
USER agent
RUN npm install -g @mariozechner/pi-coding-agent
RUN node --version && pi --version

# --------------------------------------------------------------------------
# Post-build setup (the sandbox runtime wipes custom files, ENTRYPOINT, CMD)
# --------------------------------------------------------------------------
#
# 1. Build and push the image:
#      docker build -t ghcr.io/erykpiast/pi-sandbox:v3 --push .
#
# 2. Create a sandbox from the image:
#      sbx run -t ghcr.io/erykpiast/pi-sandbox:v3 shell
#
# 3. Inside the sandbox, symlink fd where pi expects it:
#      mkdir -p ~/.pi/agent/bin && ln -s /usr/bin/fdfind ~/.pi/agent/bin/fd
#
# 4. Inside the sandbox, configure pi to auto-launch:
#      echo '[ -t 0 ] && [ -z "$PI_LAUNCHED" ] && export PI_LAUNCHED=1 && exec pi' \
#        | sudo tee -a /etc/sandbox-persistent.sh
#
# 5. From the host, stop and save the sandbox as a reusable template:
#      sbx stop shell-pi-sandbox
#      sbx template save shell-pi-sandbox pi-sandbox:v3
#
# 6. Run the final template:
#      sbx run -t pi-sandbox:v3 shell
