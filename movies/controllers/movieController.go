package controllers

import (
	"encoding/json"
	"log"
	"net/http"

	//"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/movies/common"
	"github.com/mmorejon/cinema/movies/data"
)

// Handler for HTTP Get - "/movies"
// Returns all Movie documents
func GetMovies(w http.ResponseWriter, r *http.Request) {
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("movies")
	repo := &data.MovieRepository{c}
	movies := repo.GetAll()
	j, err := json.Marshal(MoviesResource{Data: movies})
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)

	log.Println("[GetMovies]:")
}
