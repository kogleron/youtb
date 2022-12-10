//go:build wireinject
// +build wireinject

package main

import (
	"github.com/google/wire"

	"github.com/kogleron/youtb/internal/apps"
	"github.com/kogleron/youtb/internal/bootstrap"
)

func initTgbot() (*apps.Tgbot, error) { //nolint
	wire.Build(
		bootstrap.NewTgbotConf,
		apps.NewTgbot,
	)

	return &apps.Tgbot{}, nil
}
