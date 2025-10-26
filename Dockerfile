FROM python:3.12-slim

# Set working dir
WORKDIR /app

# Install required tools (git + pipreqs)
RUN apt-get update && \
    apt-get install -y git && \
    pip install --no-cache-dir pipreqs && \
    rm -rf /var/lib/apt/lists/*

# Clone latest version of the script directly from GitHub
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# Automatically detect Python dependencies
RUN pipreqs /app --force

# (Optional) Display what was found — useful for debugging
RUN echo "=== Generated requirements.txt ===" && cat requirements.txt && echo "==================================="

# Install detected dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Clean up unneeded packages
RUN apt-get remove -y git && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Add loop runner
COPY entry.sh .
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
