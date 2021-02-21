package main

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/mmorejon/microservices-docker-go-mongodb/users/pkg/models"
)

func (app *application) all(w http.ResponseWriter, r *http.Request) {
	// Get all user stored
	users, err := app.users.All()
	if err != nil {
		app.serverError(w, err)
	}

	// Convert user list into json encoding
	b, err := json.Marshal(users)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Users have been listed")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) findByID(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Find user by id
	m, err := app.users.FindByID(id)
	if err != nil {
		if err.Error() == "ErrNoDocuments" {
			app.infoLog.Println("User not found")
			return
		}
		// Any other error will send an internal server error
		app.serverError(w, err)
	}

	// Convert user to json encoding
	b, err := json.Marshal(m)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Println("Have been found a user")

	// Send response back
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(b)
}

func (app *application) insert(w http.ResponseWriter, r *http.Request) {
	// Define user model
	var u models.User
	// Get request information
	err := json.NewDecoder(r.Body).Decode(&u)
	if err != nil {
		app.serverError(w, err)
	}

	// Insert new user
	insertResult, err := app.users.Insert(u)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("New user have been created, id=%s", insertResult.InsertedID)
}

func (app *application) delete(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	id := vars["id"]

	// Delete user by id
	deleteResult, err := app.users.Delete(id)
	if err != nil {
		app.serverError(w, err)
	}

	app.infoLog.Printf("Have been eliminated %d user(s)", deleteResult.DeletedCount)
}
