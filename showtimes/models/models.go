package models

import (
	"time"

	"gopkg.in/mgo.v2/bson"
)

type (
	ShowTime struct {
		Id        bson.ObjectId `bson:"_id,omitempty" json:"id"`
		Date      string        `json:"date"`
		CreatedOn time.Time     `json:"createdon,omitempty"`
		Movies    []string      `json:"movies"`
	}
)
