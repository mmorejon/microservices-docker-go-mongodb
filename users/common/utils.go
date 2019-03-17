package common

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"gopkg.in/mgo.v2"
)

type (
	appError struct {
		Error      string `json:"error"`
		Message    string `json:"message"`
		HttpStatus int    `json:"status"`
	}
	errorResource struct {
		Data appError `json:"data"`
	}
	configuration struct {
		Server, MongoDBHost, DBUser, DBPwd, Database string
	}
)

func DisplayAppError(w http.ResponseWriter, handlerError error, message string, code int) {
	errObj := appError{
		Error:      handlerError.Error(),
		Message:    message,
		HttpStatus: code,
	}
	log.Printf("AppError]: %s\n", handlerError)
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(code)
	if j, err := json.Marshal(errorResource{Data: errObj}); err == nil {
		w.Write(j)
	}
}

// AppConfig holds the configuration values from config.json file
var AppConfig configuration

// Initialize AppConfig
func initConfig() {
	file, err := os.Open("common/config.json")
	defer file.Close()
	if err != nil {
		log.Fatalf("[loadConfig]: %s\n", err)
	}
	decoder := json.NewDecoder(file)
	AppConfig = configuration{}
	err = decoder.Decode(&AppConfig)
	if err != nil {
		log.Fatalf("[logAppConfig]: %s\n", err)
	}

	// Load configuration from environment values if exists
	loadConfigFromEnvironment(&AppConfig)
}

// Load configuration from environment
func loadConfigFromEnvironment(appConfig *configuration)  {
	server, ok := os.LookupEnv("CINEMA_USERS")
	if ok {
		appConfig.Server = server	
		log.Printf("[INFO]: Server information loaded from env.")
	}
	
	mongodbHost, ok := os.LookupEnv("MONGODB_HOST")
	if ok {
		appConfig.MongoDBHost = mongodbHost	
		log.Printf("[INFO]: MongoDB host information loaded from env.")
	}
	
	mongodbUser, ok := os.LookupEnv("MONGODB_USER")
	if ok {
		appConfig.DBUser = mongodbUser
		log.Printf("[INFO]: MongoDB user information loaded from env.")
	}
	
	mongodbPwd, ok := os.LookupEnv("MONGODB_PWD")
	if ok {
		appConfig.DBPwd = mongodbPwd
		log.Printf("[INFO]: MongoDB password information loaded from env.")
	}
	
	database, ok := os.LookupEnv("MONGODB_DATABASE")
	if ok {
		appConfig.Database = database
		log.Printf("[INFO]: MongoDB database information loaded from env.")
	}
}

// Session holds the mongodb session for database access
var session *mgo.Session

// GetSession gets database session
func GetSession() *mgo.Session {
	if session == nil {
		var err error
		session, err = mgo.DialWithInfo(&mgo.DialInfo{
			Addrs:    []string{AppConfig.MongoDBHost},
			Username: AppConfig.DBUser,
			Password: AppConfig.DBPwd,
			Timeout:  60 * time.Second,
		})
		if err != nil {
			log.Fatalf("[GetSession]: %s\n", err)
		}
	}
	return session
}

// Create database session
func createDbSession() {
	var err error
	session, err = mgo.DialWithInfo(&mgo.DialInfo{
		Addrs:    []string{AppConfig.MongoDBHost},
		Username: AppConfig.DBUser,
		Password: AppConfig.DBPwd,
		Timeout:  60 * time.Second,
	})
	if err != nil {
		log.Fatalf("[createDbSession]: %s\n", err)
	}
}
