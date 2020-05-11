FROM golang:1.14 AS gobuild
WORKDIR /go/src/github.com/trstringer/long-op-upgrade
COPY main.go .
RUN go get ./...
RUN go build -o bin/app

FROM debian:bullseye
WORKDIR /usr/bin/local
COPY --from=gobuild /go/src/github.com/trstringer/long-op-upgrade/bin/app .
CMD ["./app"]
