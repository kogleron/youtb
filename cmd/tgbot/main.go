package main

import (
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load(".env.local", ".env")
	if err != nil {
		panic(err)
	}

	Tgbot, err := initTgbot()
	if err != nil {
		panic(err)
	}

	Tgbot.Run()
}
