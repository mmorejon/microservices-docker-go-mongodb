# golang image where workspace (GOPATH) configured at /go.
FROM golang:1.6

# Install dependencies
RUN go get gopkg.in/mgo.v2
RUN go get github.com/gorilla/mux

# copy the local package files to the container workspace
ADD . /go/src/github.com/mmorejon/cinema/showtimes

# Setting up working directory
WORKDIR /go/src/github.com/mmorejon/cinema/showtimes

# Build the showtimes command inside the container.
RUN go install github.com/mmorejon/cinema/showtimes

# Run the script command when the container starts.
ENTRYPOINT ./run.sh

# Service listens on port 8080.
EXPOSE 8080
