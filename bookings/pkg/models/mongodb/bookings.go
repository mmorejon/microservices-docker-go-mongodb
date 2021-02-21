package mongodb

import (
	"context"
	"errors"

	"github.com/mmorejon/microservices-docker-go-mongodb/bookings/pkg/models"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// BookingModel represent a mgo database session with a booking data model
type BookingModel struct {
	C *mongo.Collection
}

// All method will be used to get all records from bookings table
func (m *BookingModel) All() ([]models.Booking, error) {
	// Define variables
	ctx := context.TODO()
	b := []models.Booking{}

	// Find all bookings
	bookingCursor, err := m.C.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	err = bookingCursor.All(ctx, &b)
	if err != nil {
		return nil, err
	}

	return b, err
}

// FindByID will be used to find a booking registry by id
func (m *BookingModel) FindByID(id string) (*models.Booking, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}

	// Find booking by id
	var booking = models.Booking{}
	err = m.C.FindOne(context.TODO(), bson.M{"_id": p}).Decode(&booking)
	if err != nil {
		// Checks if the booking was not found
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("ErrNoDocuments")
		}
		return nil, err
	}

	return &booking, nil
}

// Insert will be used to insert a new booking registry
func (m *BookingModel) Insert(booking models.Booking) (*mongo.InsertOneResult, error) {
	return m.C.InsertOne(context.TODO(), booking)
}

// Delete will be used to delete a booking registry
func (m *BookingModel) Delete(id string) (*mongo.DeleteResult, error) {
	p, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return nil, err
	}
	return m.C.DeleteOne(context.TODO(), bson.M{"_id": p})
}
