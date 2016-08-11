# golang image where workspace (GOPATH) configured at /go.
FROM golang:1.6

# copy the local package files to the container workspace
ADD . /go/src/github.com/mmorejon/cinema/movies

# Get godeps for managing and restoring dependencies
#RUN go get github.com/tools/godep

# Restore godep dependencies
#RUN godep restore

# Setting up working directory
WORKDIR /go/src/github.com/mmorejon/cinema/movies

# Run the movie command when the container starts.
#ENTRYPOINT /go/bin/moviesa

# Service listens on port 8080.
EXPOSE 8080