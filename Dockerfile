FROM python:3.12-slim

WORKDIR /app

# Install git and pip tools
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone latest version of the script
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# Detect and install missing dependencies automatically
RUN python - <<'PYCODE'
import sys, subprocess, importlib.util, re, pkgutil
from pathlib import Path

code = Path("HDHomeRunEPG_To_XmlTv.py").read_text()
imports = set(re.findall(r'^\s*(?:from|import)\s+([\w\.]+)', code, re.MULTILINE))

# Standard lib modules set
stdlib = {m.name for m in pkgutil.iter_modules()}
# Always treat builtins as standard
stdlib.update(sys.builtin_module_names)

to_install = []
for mod in imports:
    root = mod.split('.')[0]
    if root not in stdlib:
        spec = importlib.util.find_spec(root)
        if spec is None:
            to_install.append(root)

if to_install:
    print("Installing detected external modules:", to_install)
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--no-cache-dir", *to_install])
else:
    print("No external dependencies found")
PYCODE

# Clean up
RUN apt-get remove -y git && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Add entrypoint
COPY entry.sh .
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
