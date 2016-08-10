package controllers

import (
	"encoding/json"
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
}

// Handler for HTTP Post - "/movies"
// Insert a new Movie document
func CreateMovie(w http.ResponseWriter, r *http.Request) {
	var dataResourse MovieResource
	// Decode the incoming Movie json
	err := json.NewDecoder(r.Body).Decode(&dataResourse)
	if err != nil {
		common.DisplayAppError(w, err, "Invalid Movie data", 500)
		return
	}
	movie := &dataResourse.Data

	// create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("movies")
	// Insert a movie document
	repo := &data.MovieRepository{c}
	repo.Create(movie)
	j, err := json.Marshal(dataResourse)
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}
