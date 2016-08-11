package controllers

import (
	"github.com/mmorejon/cinema/showtimes/models"
)

type (
	// For Get - /showtimes
	ShowTimesResource struct {
		Data []models.ShowTime `json:"data"`
	}
	// For Post/Put - /showtimes
	ShowTimeResource struct {
		Data models.ShowTime `json:"data"`
	}
)
