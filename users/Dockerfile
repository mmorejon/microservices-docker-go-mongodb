# golang image where workspace (GOPATH) configured at /go.
FROM golang:1.6

# copy the local package files to the container workspace
ADD . /go/src/github.com/mmorejon/cinema/users

# Setting up working directory
WORKDIR /go/src/github.com/mmorejon/cinema/users

# Get godeps for managing and restoring dependencies
RUN go get github.com/tools/godep

# Restore godep dependencies
RUN godep restore

# Build the users command inside the container.
RUN go install github.com/mmorejon/cinema/users

# Run the taskmanager command when the container starts.
ENTRYPOINT /go/bin/users

# Service listens on port 8080.
EXPOSE 8080
