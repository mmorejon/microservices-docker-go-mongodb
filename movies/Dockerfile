# golang image where workspace (GOPATH) configured at /go.
FROM golang:1.11.2 as dev

# Install dependencies
RUN go get gopkg.in/mgo.v2
RUN go get github.com/gorilla/mux

# copy the local package files to the container workspace
ADD . /go/src/github.com/mmorejon/cinema/movies

# Setting up working directory
WORKDIR /go/src/github.com/mmorejon/cinema/movies

# build binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o movies .


# alpine image
FROM alpine:3.9.2 as prod
# Setting up working directory
WORKDIR /root/
# copy movies binary
COPY --from=dev /go/src/github.com/mmorejon/cinema/movies .
# Service listens on port 8080.
EXPOSE 8080
# Run the movies microservice when the container starts.
ENTRYPOINT ["./movies"]