package controllers

import (
	"github.com/mmorejon/cinema/movies/models"
)

type (
	// For Get - /notes
	// For /notes/tasks/id
	MoviesResource struct {
		Data []models.Movie `json:"data"`
	}
)
