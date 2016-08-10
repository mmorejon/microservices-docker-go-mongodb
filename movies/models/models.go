package models

import (
	"time"

	"gopkg.in/mgo.v2/bson"
)

type (
	Movie struct {
		Id        bson.ObjectId `bson:"_id,omitempty" json:"id"`
		Title     string        `json:"title"`
		Director  string        `json:"director"`
		Rating    float32       `json:"rating"`
		CreatedOn time.Time     `json:"createdon,omitempty"`
	}
)
