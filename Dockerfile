FROM python:3.12-slim

WORKDIR /app

# Install system dependencies and Python packages in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    pip install --no-cache-dir pytz tzlocal && \
    apt-get remove -y git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Clone the script directly from GitHub
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# Copy the entry script and make executable
COPY entry.sh . 
RUN chmod +x entry.sh

# Set entrypoint
ENTRYPOINT ["./entry.sh"]
