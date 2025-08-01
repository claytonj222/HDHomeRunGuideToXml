FROM python:3.12-slim

# Set working dir
WORKDIR /app

# Install git and Python deps
RUN apt-get update && \
    apt-get install -y git && \
    pip install --no-cache-dir requests && \
    apt-get remove -y git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Clone latest version of the script directly from GitHub
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# Add loop runner
COPY run_epg_loop.sh .
RUN chmod +x run_epg_loop.sh

ENTRYPOINT ["./run_epg_loop.sh"]
