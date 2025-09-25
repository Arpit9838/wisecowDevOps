# # Dockerfile - Simple container for wisecow (bash-based)
# FROM debian:12-slim

# # Install required packages
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#       curl \
#       netcat-openbsd \
#       fortune-mod \
#       cowsay && \
#     rm -rf /var/lib/apt/lists/*

# # Add the wisecow script
# WORKDIR /app
# COPY wisecow.sh /app/wisecow.sh
# RUN chmod +x /app/wisecow.sh

# # Use a non-root user
# RUN useradd -m -s /bin/bash appuser && chown -R appuser:appuser /app
# USER appuser

# EXPOSE 4499

# # Start the script (wisecow.sh should listen on 0.0.0.0:4499)
# CMD ["/app/wisecow.sh"]

FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    netcat-openbsd \
    cowsay \
    fortune-mod \
    fortunes \
    dos2unix && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY wisecow.sh /app/wisecow.sh
RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh

# Ensure cowsay and fortune are available in PATH
RUN ln -s /usr/games/cowsay /usr/bin/cowsay && \
    ln -s /usr/games/fortune /usr/bin/fortune

RUN useradd -m -s /bin/bash appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 4499
ENTRYPOINT ["/app/wisecow.sh"]
