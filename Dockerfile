FROM python:3.12-slim

# Set working dir
WORKDIR /app

# Install git and Python deps
RUN apt-get update && \
    apt-get install -y git && \
    pip install --no-cache-dir pytz tzlocal && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Clone latest version of the script directly from GitHub
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

RUN apt-get remove -y git

# Add loop runner
COPY entry.sh .
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
