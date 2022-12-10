package bootstrap

import (
	"github.com/kelseyhightower/envconfig"

	"github.com/kogleron/youtb/internal/apps"
)

func NewTgbotConf() apps.TgbotConf {
	conf := apps.TgbotConf{}

	err := envconfig.Process("Tgbot", &conf)
	if err != nil {
		panic(err)
	}

	return conf
}
