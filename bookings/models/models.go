package models

import (
	"gopkg.in/mgo.v2/bson"
)

type (
	Booking struct {
		Id         bson.ObjectId `bson:"_id,omitempty" json:"id"`
		UserId     string        `json:"user_id	,omitempty"`
		Date       string        `json:"date	,omitempty"`
		ShowTimeId string        `json:"showtime_id	,omitempty"`
	}
)
