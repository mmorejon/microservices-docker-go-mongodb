package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/movies/common"
	"github.com/mmorejon/cinema/movies/data"
	"gopkg.in/mgo.v2"
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

// Handler for HTTP Get - "/movies/{id}"
// Get movie by id
func GetMovieById(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("movies")
	repo := &data.MovieRepository{c}

	// Get movie by id
	movie, err := repo.GetById(id)
	if err != nil {
		if err == mgo.ErrNotFound {
			w.WriteHeader(http.StatusNotFound)
			return
		} else {
			common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
			return
		}
	}

	j, err := json.Marshal(MovieResource{Data: movie})
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}

// Handler for HTTP Delete - "/movies/{id}"
// Delete movie by id
func DeleteMovie(rw http.ResponseWriter, req *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(req)
	id := vars["id"]

	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("movies")
	repo := &data.MovieRepository{c}

	err := repo.Delete(id)
	if err != nil {
		if err == mgo.ErrNotFound {
			rw.WriteHeader(http.StatusNotFound)
			return
		} else {
			common.DisplayAppError(rw, err, "An unexpected error has occurred", 500)
			return
		}
	}
	rw.WriteHeader(http.StatusNoContent)
}
