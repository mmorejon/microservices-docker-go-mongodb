package models

import (
	"gopkg.in/mgo.v2/bson"
)

type (
	Booking struct {
		Id         bson.ObjectId `bson:"_id,omitempty" json:"id"`
		UserId     string        `json:"userid"`
		ShowtimeId string        `json:"showtimeid"`
		Movies     []string      `json:"movies"`
	}
)
