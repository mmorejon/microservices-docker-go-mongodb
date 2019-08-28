# Cinema - Example of Microservices in Go with Docker and MongoDB

### Overview

Cinema is an example project which demonstrates the use of microservices for a fictional movie theater.
The Cinema backend is powered by 4 microservices, all of witch happen to be written in Go, using MongoDB for manage the database and Docker to isolate and deploy the ecosystem.

 * Movie Service: Provides information like movie ratings, title, etc.
 * Show Times Service: Provides show times information.
 * Booking Service: Provides booking information. 
 * Users Service: Provides movie suggestions for users by communicating with other services.

The Cinema use case is based on the project written in Python by [Umer Mansoor](https://github.com/umermansoor/microservices).

The proyect structure is based in the knowledge learned in the book: Web
Development with Go by Shiju Varghese, ISBN 978-1-4842-1053-6

## Deployment

The application can be deployed in both environments: **local machine** or in a **kubernetes cluster**. You can find the appropriate documentation for each case in the following links:

* [localhost](./docs/localhost.md)
* [kubernetes](./docs/kubernetes.md)

## How To Use Cinema Services

* [endpoints](./docs/endpoints.md)

### Significant Revisions

* [Microservices - Martin Fowler](http://martinfowler.com/articles/microservices.html)
* [Web Development with Go](http://www.apress.com/9781484210536)
* [Umer Mansoor - Cinema](https://github.com/umermansoor/microservices)
* [Traefik](https://traefik.io/)