package models

import "go.mongodb.org/mongo-driver/bson/primitive"

// User is used to represent user profile data
type User struct {
	ID       primitive.ObjectID `bson:"_id,omitempty"`
	Name     string             `bson:"name,omitempty"`
	LastName string             `bson:"lastname,omitempty"`
}
