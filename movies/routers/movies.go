package routers

import (
	"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/movies/controllers"
)

func setMovieRouters(router *mux.Router) *mux.Router {
	router.HandleFunc("/movies", controllers.GetMovies).Methods("GET")
	return router
}
