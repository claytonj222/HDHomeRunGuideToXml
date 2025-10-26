FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone your script
RUN git clone --depth=1 https://github.com/IncubusVictim/HDHomeRunEPG-to-XmlTv.git repo && \
    mv repo/HDHomeRunEPG_To_XmlTv.py ./ && \
    rm -rf repo

# Let pip install everything the script actually imports by trying to run it
# If an ImportError occurs, install that module and retry until it runs
RUN python - <<'PYCODE'
import runpy, subprocess, sys, importlib

while True:
    try:
        runpy.run_path("HDHomeRunEPG_To_XmlTv.py", run_name="__main__")
        break
    except ModuleNotFoundError as e:
        pkg = e.name
        print(f"Installing missing dependency: {pkg}")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--no-cache-dir", pkg])
    except SystemExit:
        # script calls sys.exit(); treat as success
        break
    except Exception as e:
        # any other runtime error should break to avoid endless loop
        print("Non-import error during detection:", e)
        break
PYCODE

# Clean up
RUN apt-get remove -y git && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY entry.sh .
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
