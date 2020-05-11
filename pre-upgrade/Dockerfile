FROM debian:bullseye

RUN apt-get update && apt-get install -y curl python3

WORKDIR /usr/bin/local
COPY pre-upgrade.sh .
CMD ["./pre-upgrade.sh"]
