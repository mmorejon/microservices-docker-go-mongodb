package mongodb

import (
	"context"
	"errors"

	"github.com/mmorejon/microservices-docker-go-mongodb/movies/pkg/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// MovieModel represent a mgo database session with a movie data model.
type MovieModel struct {
	C *mongo.Collection
}

// All method will be used to get all records from the movies table.
func (m *MovieModel) All() ([]models.Movie, error) {
	// Define variables
	ctx := context.TODO()
	mm := []models.Movie{}

	// Find all movies
	movieCursor, err := m.C.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	err = movieCursor.All(ctx, &mm)
	if err != nil {
		return nil, err
	}

	return mm, err
}

// FindByID will be used to find a new movie registry by id
func (m *MovieModel) FindByID(id string) (*models.Movie, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}

	// Find movie by id
	var movie = models.Movie{}
	err = m.C.FindOne(context.TODO(), bson.M{"_id": p}).Decode(&movie)
	if err != nil {
		// Checks if the movie was not found
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("ErrNoDocuments")
		}
		return nil, err
	}

	return &movie, nil
}

// Insert will be used to insert a new movie registry
func (m *MovieModel) Insert(movie models.Movie) (*mongo.InsertOneResult, error) {
	return m.C.InsertOne(context.TODO(), movie)
}

// Delete will be used to delete a movie registry
func (m *MovieModel) Delete(id string) (*mongo.DeleteResult, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}
	return m.C.DeleteOne(context.TODO(), bson.M{"_id": p})
}
