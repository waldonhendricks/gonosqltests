FROM golang:1.10.3 as builder

WORKDIR ${GOPATH}/src/github.com/boniface/gonosqltests
COPY . .
RUN set -x && \
    go get -d -v . && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o gonosqltests .


FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder go/src/github.com/boniface/gonosqltests .
CMD ["./gonosqltests"]


# Expose the application on port 8080.
# This should be the same as in the app.conf file
EXPOSE 8080