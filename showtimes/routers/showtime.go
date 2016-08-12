package routers

import (
	"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/showtimes/controllers"
)

func SetShowTimeRouters(router *mux.Router) *mux.Router {
	router.HandleFunc("/showtimes", controllers.GetShowTimes).Methods("GET")
	router.HandleFunc("/showtimes", controllers.CreateShowTime).Methods("POST")
	router.HandleFunc("/showtimes/{date}", controllers.GetShowTimeByDate).Methods("GET")
	router.HandleFunc("/showtimes/{id}", controllers.DeleteShowTime).Methods("DELETE")
	return router
}
