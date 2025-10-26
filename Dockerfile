FROM python:3.12-slim

WORKDIR /app

# Install git and dependencies
RUN apt-get update && \
    apt-get install -y git && \
    pip install --no-cache-dir requests pytz tzlocal && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ARG USE_CUSTOM_SCRIPT=false
COPY HDHomeRunEPG_To_XmlTv_Custom.py ./HDHomeRunEPG_To_XmlTv_Custom.py

RUN if [ "$USE_CUSTOM_SCRIPT" = "true" ]; then \
        echo "Using custom script"; \
        cp ./HDHomeRunEPG_To_XmlTv_Custom.py ./HDHomeRunEPG_To_XmlTv.py; \
    else \
        echo "Using original script from GitHub"; \
        git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
        mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
        rm -rf repo; \
    fi && \
    apt-get remove -y git

COPY entry.sh . 
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
