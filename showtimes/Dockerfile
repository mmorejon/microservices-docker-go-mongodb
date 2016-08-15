# golang image where workspace (GOPATH) configured at /go.
FROM golang:1.6

# copy the local package files to the container workspace
ADD . /go/src/github.com/mmorejon/cinema/showtimes

# Setting up working directory
WORKDIR /go/src/github.com/mmorejon/cinema/showtimes

# Get godeps for managing and restoring dependencies
RUN go get github.com/tools/godep

# Restore godep dependencies
RUN godep restore

# Build the showtimes command inside the container.
RUN go install github.com/mmorejon/cinema/showtimes

# Run the taskmanager command when the container starts.
ENTRYPOINT /go/bin/showtimes

# Service listens on port 8080.
EXPOSE 8080
