package data

import (
	"time"

	"github.com/mmorejon/cinema/showtimes/models"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

type ShowTimeRepository struct {
	C *mgo.Collection
}

func (r *ShowTimeRepository) Create(showtime *models.ShowTime) error {
	obj_id := bson.NewObjectId()
	showtime.Id = obj_id
	showtime.CreatedOn = time.Now()
	err := r.C.Insert(&showtime)
	return err
}

func (r *ShowTimeRepository) GetAll() []models.ShowTime {
	var showtimes []models.ShowTime
	iter := r.C.Find(nil).Iter()
	result := models.ShowTime{}
	for iter.Next(&result) {
		showtimes = append(showtimes, result)
	}
	return showtimes
}

func (r *ShowTimeRepository) GetByDate(date string) (showtime models.ShowTime, err error) {
	err = r.C.Find(bson.M{"date": date}).One(&showtime)
	return
}

func (r *ShowTimeRepository) Delete(id string) error {
	err := r.C.Remove(bson.M{"_id": bson.ObjectIdHex(id)})
	return err
}
