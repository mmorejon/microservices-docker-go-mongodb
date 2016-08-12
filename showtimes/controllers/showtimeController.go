package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/mmorejon/cinema/showtimes/common"
	"github.com/mmorejon/cinema/showtimes/data"
	"gopkg.in/mgo.v2"
)

// Handler for HTTP Get - "/showtimes"
// Returns all Showtime documents
func GetShowTimes(w http.ResponseWriter, r *http.Request) {
	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("showtimes")
	repo := &data.ShowTimeRepository{c}
	// Get all showtimes form repository
	showtimes := repo.GetAll()
	j, err := json.Marshal(ShowTimesResource{Data: showtimes})
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}

// Handler for HTTP Post - "/showtimes"
// Create a new Showtime document
func CreateShowTime(w http.ResponseWriter, r *http.Request) {
	var dataResource ShowTimeResource
	// Decode the incoming ShowTime json
	err := json.NewDecoder(r.Body).Decode(&dataResource)
	if err != nil {
		common.DisplayAppError(w, err, "Invalid ShowTime data", 500)
		return
	}
	showtime := &dataResource.Data
	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("showtimes")
	// Create ShowTime
	repo := &data.ShowTimeRepository{c}
	repo.Create(showtime)
	// Create response data
	j, err := json.Marshal(dataResource)
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}

func GetShowTimeByDate(w http.ResponseWriter, r *http.Request) {
	// Get date from incoming url
	vars := mux.Vars(r)
	date := vars["date"]

	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("showtimes")
	repo := &data.ShowTimeRepository{c}

	// Get showtime by date
	showtime, err := repo.GetByDate(date)
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	// Create data for the response
	j, err := json.Marshal(ShowTimeResource{Data: showtime})
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}

// Handler for HTTP Delete - "/showtimes/{id}"
// Delete a Showtime document by id
func DeleteShowTime(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("showtimes")

	// Remove showtime by id
	repo := &data.ShowTimeRepository{c}
	err := repo.Delete(id)
	if err != nil {
		if err == mgo.ErrNotFound {
			w.WriteHeader(http.StatusNotFound)
			return
		} else {
			common.DisplayAppError(w, err, "An unexpected error ahs occurred", 500)
			return
		}
	}

	// Send response back
	w.WriteHeader(http.StatusNoContent)
}
