package routers

import (
	"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/movies/controllers"
)

func setMovieRouters(router *mux.Router) *mux.Router {
	router.HandleFunc("/movies", controllers.GetMovies).Methods("GET")
	router.HandleFunc("/movies", controllers.CreateMovie).Methods("POST")
	router.HandleFunc("/movies/{id}", controllers.GetMovieById).Methods("GET")
	router.HandleFunc("/movies/{id}", controllers.DeleteMovie).Methods("DELETE")
	return router
}
