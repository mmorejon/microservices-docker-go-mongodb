# Cinema - Localhost Deployment

### Overview

The Cinema project can be deployed in a single machine (localhost) in order to know the behavior of microservices.

### Requirements

* Docker 18.06.1-ce
* Docker Compose 1.23.1

We must **add virtual domains** in order to use each **api entry point**. By default we are using: **movies.local**, **bookings.local**, **users.local**, **showtimes.local** and **monitor.local**

**Virtual domains** has been defined in `docker-compose.yml` file and configured in `/etc/hosts` file. Add the following line in your `/etc/hosts` file:

```
127.0.0.1   movies.local bookings.local users.local showtimes.local monitor.local
```

**monitor.local** will be used to see the Dashboard created by Traefik.

## Starting services

```
docker-compose up -d
```

## Stoping services

```
docker-compose stop
```

## Including new changes

If you need change some source code you can deploy it typing:

```
docker-compose build
```

## Restore database information

You can start using an empty database for all microservices, but if you want you can restore a preconfigured data execute this step:

**_Restore mongodb data typing:_**

This command will go inside the mongodb container (`db` service described in `docker-compose.yml` file) and will execute the script `restore.sh` located in `/backup/restore.sh`. Once the script finished the data inserted will be ready to be consulted.

```
docker-compose exec db /bin/bash /backup/restore.sh
```

## Traefik Dashboard

Access to the dashboard to see how Traefik organize the links.

* http://monitor.local : Get Traefik dashboard

<img src="../img/traefik-dashboard.png" alt="Traefik Dashboard" title="Traefik Dashboard" />

Next: [Endpoints](endpoints.md)