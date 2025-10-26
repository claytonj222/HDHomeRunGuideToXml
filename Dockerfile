FROM python:3.12-slim

WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone your script
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# --- AUTO-DETECT AND INSTALL DEPENDENCIES ---
RUN python - <<'PYCODE'
import subprocess, sys, re
from pathlib import Path

code = Path("HDHomeRunEPG_To_XmlTv.py").read_text()
imports = set(re.findall(r'^\s*(?:from|import)\s+([\w\.]+)', code, re.MULTILINE))

failed = []
for mod in imports:
    root = mod.split('.')[0]
    try:
        __import__(root)
    except ModuleNotFoundError:
        failed.append(root)

if failed:
    print("Installing missing modules:", failed)
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--no-cache-dir", *failed])
else:
    print("All imports already satisfied.")
PYCODE
# --------------------------------------------

# Clean up
RUN apt-get remove -y git && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Add runner
COPY entry.sh .
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
