# golang alpine 1.15.6-alpine as base image
FROM golang:1.16.7-alpine AS builder
# create appuser.
RUN adduser -D -g '' elf
# create workspace
WORKDIR /opt/app/
COPY go.mod go.sum ./
# fetch dependancies
RUN go mod download && \
    go mod verify
# copy the source code as the last step
COPY . .
# build binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/cinema-showtimes ./cmd/app


# build a small image
FROM alpine:3.14.1
LABEL language="golang"
LABEL org.opencontainers.image.source https://github.com/autotune/microservices-docker-go-mongodb-tf
# import the user and group files from the builder
COPY --from=builder /etc/passwd /etc/passwd
# copy the static executable
COPY --from=builder /go/bin/cinema-showtimes /cinema-showtimes
# change permissions since doing so via COPY --chown=elf:1000 fails
RUN chown -R elf:"$(id -g elf)" /cinema-showtimes

# use a non-root user
USER elf
# run app
ENTRYPOINT ["./cinema-showtimes"]
