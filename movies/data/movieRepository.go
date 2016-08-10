package data

import (
	"github.com/mmorejon/cinema/movies/models"
	"gopkg.in/mgo.v2"
)

type MovieRepository struct {
	C *mgo.Collection
}

func (r *MovieRepository) GetAll() []models.Movie {
	var movies []models.Movie
	iter := r.C.Find(nil).Iter()
	result := models.Movie{}
	for iter.Next(&result) {
		movies = append(movies, result)
	}
	return movies
}
