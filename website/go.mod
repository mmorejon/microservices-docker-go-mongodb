module github.com/mmorejon/microservices-docker-go-mongodb/website

go 1.19

require (
	github.com/gorilla/mux v1.8.0
	github.com/mmorejon/microservices-docker-go-mongodb/bookings v0.0.0-20221030191256-4469296596ed
	github.com/mmorejon/microservices-docker-go-mongodb/movies v0.0.0-20221030191256-4469296596ed
	github.com/mmorejon/microservices-docker-go-mongodb/showtimes v0.0.0-20221030191256-4469296596ed
	github.com/mmorejon/microservices-docker-go-mongodb/users v0.0.0-20221030191256-4469296596ed
)

require go.mongodb.org/mongo-driver v1.7.1 // indirect
