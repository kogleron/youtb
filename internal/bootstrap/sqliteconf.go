package bootstrap

import (
	"github.com/kelseyhightower/envconfig"

	"github.com/kogleron/youtb/internal/sqlite"
)

func NewSqliteConf() (sqlite.Conf, error) {
	conf := sqlite.Conf{}

	err := envconfig.Process("SQLITE", &conf)
	if err != nil {
		return conf, err
	}

	return conf, nil
}
