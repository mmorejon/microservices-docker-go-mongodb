# Cinema - Example of Microservices in Go with Docker and MongoDB

Overview
========

Cinema is an example project which demonstrates the use of microservices for a fictional movie theater.
The Cinema backend is powered by 4 microservices, all of witch happen to be written in Go, using MongoDB for manage the database and Docker to isolate and deploy the ecosystem.

 * Movie Service: Provides information like movie ratings, title, etc.
 * Show Times Service: Provides show times information.
 * Booking Service: Provides booking information. 
 * Users Service: Provides movie suggestions for users by communicating with other services.

The Cinema use case is based on the project written in Python .... by ...
The proyect structure is based in the knowledge learned in the book: Web
Development with Go by Shiju Varghese, ISBN 978-1-4842-1053-6

Requirements
===========

* Go 1.6
* MongoDB 3.3
* Docker 1.12

Install
=======



Starting and Stopping Services
==============================



Documentation
======================

## Movie Service

This service is used to get information about a movie. It provides the movie title, rating on a 1-10 scale, director and other information.

## Showtimes Service

This service is used get a list of movies playing on a certain date.

## Booking Service

Used to lookup booking information for users.

## User Service

This service returns information about the users of Cinema 3 and also provides movie suggestions to the users. It communicates with other services to retrieve booking or movie information.