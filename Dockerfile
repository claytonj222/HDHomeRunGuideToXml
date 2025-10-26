FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install git, clone script, install Python deps, then clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo && \
    pip install --no-cache-dir pytz tzlocal && \
    apt-get remove -y git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy your entry script and make it executable
COPY entry.sh .
RUN chmod +x entry.sh

# Set entrypoint
ENTRYPOINT ["./entry.sh"]
