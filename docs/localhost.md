# Cinema - Localhost Deployment

### Overview

The Cinema project can be deployed in a single machine (localhost) using docker compose in order to know the behavior of microservices.

### Requirements

* Docker Engine  20.10.0
* Docker Compose 1.27.4

## Starting services

Use the following command to deploy all services in your local environment.

```
$ docker-compose up -d

Creating microservices-docker-go-mongodb_bookings_1  ... done
Creating microservices-docker-go-mongodb_db_1        ... done
Creating microservices-docker-go-mongodb_users_1     ... done
Creating microservices-docker-go-mongodb_movies_1    ... done
Creating microservices-docker-go-mongodb_showtimes_1 ... done
Creating microservices-docker-go-mongodb_proxy_1     ... done
```

```
$ docker-compose ps

                   Name                                  Command               State                      Ports
-----------------------------------------------------------------------------------------------------------------------------------
microservices-docker-go-mongodb_bookings_1    ./cinema-bookins -mongoURI ...   Up
microservices-docker-go-mongodb_db_1          docker-entrypoint.sh mongod      Up      27017/tcp
microservices-docker-go-mongodb_movies_1      ./cinema-movies -mongoURI  ...   Up
microservices-docker-go-mongodb_proxy_1       /entrypoint.sh --api --api ...   Up      0.0.0.0:4000->80/tcp, 0.0.0.0:8080->8080/tcp
microservices-docker-go-mongodb_showtimes_1   ./cinema-showtimes -mongoU ...   Up
microservices-docker-go-mongodb_users_1       ./cinema-users -mongoURI m ...   Up
```

Once starting all services the following links will be availables:

| Service | Description |
|---------|-------------|
| [Traefik Proxy Dashboard](http://localhost:8080/dashboard/#/) | Allows you to identify Traefik componentes like routers, provider, services, middlewares among others |
| [List users api](http://localhost:4000/api/users/) | List all users |
| [List movies api](http://localhost:4000/api/movies/) | List all movies |
| [List showtimes api](http://localhost:4000/api/showtimes/) | List all showtimes |
| [List bookings api](http://localhost:4000/api/bookings/) | List all bookings |

## Restore database information

You will start using an empty database for all microservices, but if you want you can restore a preconfigured data execute this command:

```
$ docker-compose exec db mongorestore --uri mongodb://db:27017 --gzip  /backup

2021-01-17T16:38:27.922+0000    preparing collections to restore from
2021-01-17T16:38:27.961+0000    reading metadata for cinema.users from /backup/cinema/users.metadata.json.gz
2021-01-17T16:38:27.965+0000    reading metadata for cinema.movies from /backup/cinema/movies.metadata.json.gz
2021-01-17T16:38:27.967+0000    reading metadata for cinema.showtimes from /backup/cinema/showtimes.metadata.json.gz
2021-01-17T16:38:27.977+0000    reading metadata for cinema.bookings from /backup/cinema/bookings.metadata.json.gz
2021-01-17T16:38:28.019+0000    restoring cinema.users from /backup/cinema/users.bson.gz
2021-01-17T16:38:28.036+0000    no indexes to restore
2021-01-17T16:38:28.044+0000    finished restoring cinema.users (5 documents, 0 failures)
2021-01-17T16:38:28.084+0000    restoring cinema.showtimes from /backup/cinema/showtimes.bson.gz
2021-01-17T16:38:28.099+0000    no indexes to restore
2021-01-17T16:38:28.108+0000    finished restoring cinema.showtimes (3 documents, 0 failures)
2021-01-17T16:38:28.134+0000    restoring cinema.movies from /backup/cinema/movies.bson.gz
2021-01-17T16:38:28.157+0000    restoring cinema.bookings from /backup/cinema/bookings.bson.gz
2021-01-17T16:38:28.171+0000    no indexes to restore
2021-01-17T16:38:28.179+0000    finished restoring cinema.movies (6 documents, 0 failures)
2021-01-17T16:38:28.182+0000    no indexes to restore
2021-01-17T16:38:28.184+0000    finished restoring cinema.bookings (2 documents, 0 failures)
2021-01-17T16:38:28.186+0000    16 document(s) restored successfully. 0 document(s) failed to restore.
```

This command will go inside the mongodb container (`db` service described in `docker-compose.yml` file). Once the command finished the data inserted will be ready to be consulted. Try listing users againg <http://localhost:4000/api/users/>

## Stoping services

```
docker-compose stop
```

## Traefik Proxy dashboard

This project use Traefik Proxy v2.3.7, [the dashboard should look like this image](http://localhost:8080/dashboard/#/):

![overview](images/traefik-dashboard.jpg)

Next: [Endpoints](endpoints.md)