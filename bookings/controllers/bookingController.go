package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/mmorejon/cinema/bookings/common"
	"github.com/mmorejon/cinema/bookings/data"
)

// Handler for HTTP Post - "/bookins"
// Create a new Booking document
func CreateBooking(w http.ResponseWriter, r *http.Request) {
	var dataResource BookingResource
	// Decode the incoming Booking json
	err := json.NewDecoder(r.Body).Decode(&dataResource)
	if err != nil {
		common.DisplayAppError(w, err, "Invalid Booking data", 500)
		return
	}
	booking := &dataResource.Data
	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("bookings")
	// Create Booking
	repo := &data.BookingRepository{c}
	repo.Create(booking)
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

func GetBookings(w http.ResponseWriter, r *http.Request) {
	// Create new context
	context := NewContext()
	defer context.Close()
	c := context.DbCollection("bookings")
	repo := &data.BookingRepository{c}
	// Get all bookings
	bookings := repo.GetAll()
	// Create response data
	j, err := json.Marshal(BookingsResource{Data: bookings})
	if err != nil {
		common.DisplayAppError(w, err, "An unexpected error has occurred", 500)
		return
	}
	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(j)
}
