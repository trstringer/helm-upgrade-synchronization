FROM debian:bullseye

RUN apt update && apt install -y curl python3

WORKDIR /usr/bin/local
COPY pre-upgrade.sh .
CMD ["./pre-upgrade.sh"]
