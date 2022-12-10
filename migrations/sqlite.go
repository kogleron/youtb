package main

import (
	"github.com/joho/godotenv"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"

	"github.com/kogleron/youtb/internal/bootstrap"
)

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		panic(err)
	}

	conf, err := bootstrap.NewSqliteConf()
	if err != nil {
		panic(err)
	}

	db, err := gorm.Open(sqlite.Open(conf.Database), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	err = db.AutoMigrate(&struct{}{})
	if err != nil {
		panic(err)
	}
}
