package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"text/template"

	"github.com/gorilla/mux"
	moviesModel "github.com/mmorejon/microservices-docker-go-mongodb/movies/pkg/models"
	"github.com/mmorejon/microservices-docker-go-mongodb/showtimes/pkg/models"
)

type showtimeTemplateData struct {
	ShowTime  models.ShowTime
	ShowTimes []models.ShowTime
	Movies    string
}

func (app *application) showtimesList(w http.ResponseWriter, r *http.Request) {

	// Get showtimes list from API
	app.infoLog.Println("Calling showtimes API...")
	resp, err := http.Get(app.apis.showtimes)
	if err != nil {
		fmt.Print(err.Error())
	}
	defer resp.Body.Close()

	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Print(err.Error())
	}

	var td showtimeTemplateData
	json.Unmarshal(bodyBytes, &td.ShowTimes)
	app.infoLog.Println(td.ShowTimes)

	// Load template files
	files := []string{
		"./ui/html/showtimes/list.page.tmpl",
		"./ui/html/base.layout.tmpl",
		"./ui/html/footer.partial.tmpl",
	}

	ts, err := template.ParseFiles(files...)
	if err != nil {
		app.errorLog.Println(err.Error())
		http.Error(w, "Internal Server Error", 500)
		return
	}

	err = ts.Execute(w, td)
	if err != nil {
		app.errorLog.Println(err.Error())
		http.Error(w, "Internal Server Error", 500)
	}
}

func (app *application) showtimesView(w http.ResponseWriter, r *http.Request) {
	// Get id from incoming url
	vars := mux.Vars(r)
	showtimeID := vars["id"]

	// Get showtimes list from API
	app.infoLog.Println("Calling showtimes API...")
	url := fmt.Sprintf("%s/%s", app.apis.showtimes, showtimeID)

	resp, err := http.Get(url)
	if err != nil {
		fmt.Print(err.Error())
	}
	defer resp.Body.Close()

	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Print(err.Error())
	}

	var td showtimeTemplateData
	json.Unmarshal(bodyBytes, &td.ShowTime)
	app.infoLog.Println(td.ShowTime)

	// Load movie names
	var movies []string
	for _, m := range td.ShowTime.Movies {
		url := fmt.Sprintf("%s/%s", app.apis.movies, m)

		resp, err := http.Get(url)
		if err != nil {
			fmt.Print(err.Error())
		}
		defer resp.Body.Close()

		bodyBytes, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			fmt.Print(err.Error())
		}

		var movie moviesModel.Movie
		json.Unmarshal(bodyBytes, &movie)
		movies = append(movies, movie.Title)
	}
	td.Movies = strings.Join(movies, ", ")

	// Load template files
	files := []string{
		"./ui/html/showtimes/view.page.tmpl",
		"./ui/html/base.layout.tmpl",
		"./ui/html/footer.partial.tmpl",
	}

	ts, err := template.ParseFiles(files...)
	if err != nil {
		app.errorLog.Println(err.Error())
		http.Error(w, "Internal Server Error", 500)
		return
	}

	err = ts.Execute(w, td)
	if err != nil {
		app.errorLog.Println(err.Error())
		http.Error(w, "Internal Server Error", 500)
	}
}
