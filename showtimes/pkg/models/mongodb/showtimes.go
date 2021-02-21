package mongodb

import (
	"context"
	"errors"

	"github.com/mmorejon/microservices-docker-go-mongodb/showtimes/pkg/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// ShowTimeModel represent a mgo database session with a showtime data model.
type ShowTimeModel struct {
	C *mongo.Collection
}

// All method will be used to get all records from showtimes table.
func (m *ShowTimeModel) All() ([]models.ShowTime, error) {
	// Define variables
	ctx := context.TODO()
	st := []models.ShowTime{}

	// Find all showtimes
	showtimeCursor, err := m.C.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	err = showtimeCursor.All(ctx, &st)
	if err != nil {
		return nil, err
	}

	return st, err
}

// FindByID will be used to find a showtime registry by id
func (m *ShowTimeModel) FindByID(id string) (*models.ShowTime, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}

	// Find showtime by id
	var showtime = models.ShowTime{}
	err = m.C.FindOne(context.TODO(), bson.M{"_id": p}).Decode(&showtime)
	if err != nil {
		// Checks if the showtime was not found
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("ErrNoDocuments")
		}
		return nil, err
	}

	return &showtime, nil
}

// FindByDate will be used to find a showtime registry by date
func (m *ShowTimeModel) FindByDate(date string) (*models.ShowTime, error) {
	// Find showtime by date
	var showtime = models.ShowTime{}
	err := m.C.FindOne(context.TODO(), bson.M{"date": date}).Decode(&showtime)
	if err != nil {
		// Checks if the showtime was not found
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("ErrNoDocuments")
		}
		return nil, err
	}

	return &showtime, nil
}

// Insert will be used to insert a new showtime registry
func (m *ShowTimeModel) Insert(showtime models.ShowTime) (*mongo.InsertOneResult, error) {
	return m.C.InsertOne(context.TODO(), showtime)
}

// Delete will be used to delete a showtime registry
func (m *ShowTimeModel) Delete(id string) (*mongo.DeleteResult, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}
	return m.C.DeleteOne(context.TODO(), bson.M{"_id": p})
}