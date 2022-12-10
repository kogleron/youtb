package apps

import "fmt"

func NewTgbot(conf TgbotConf) *Tgbot {
	return &Tgbot{}
}

type Tgbot struct{}

func (t Tgbot) Run() {
	fmt.Println("Hello")
}
