.DEFAULT_GOAL := help

GO       			?= go
GOFLAGS  			?=
PROJECT_NAME 	?= youtb
LOCAL_BIN = 	$(CURDIR)/bin

.PHONY: install
install: ## installs dependencies
	@echo "Install required programs"
	GOBIN=$(LOCAL_BIN) $(GO) $(GOFLAG) install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.47.3
	GOBIN=$(LOCAL_BIN) $(GO) $(GOFLAG) install mvdan.cc/gofumpt@latest
	GOBIN=$(LOCAL_BIN) $(GO) $(GOFLAG) install github.com/incu6us/goimports-reviser/v3@v3.3.0
	GOBIN=$(LOCAL_BIN) $(GO) $(GOFLAG) install github.com/google/wire/cmd/wire@latest
	GOBIN=$(LOCAL_BIN) $(GO) $(GOFLAG) install github.com/kogleron/golint-derefnil/cmd/golint-derefnil@6a95bab

.PHONY: format
format: ## formats the code and also imports order
	@echo "Formatting..."
	@for f in $$(find . -name '*.go'); do \
		$(LOCAL_BIN)/goimports-reviser -project-name $(PROJECT_NAME) $$f; \
		$(LOCAL_BIN)/gofumpt -l -w -extra $$f; \
	done

.PHONY: lint
lint: ## lints the code
	@echo "Linting..."
	@for f in $$(git status --porcelain | awk 'match($$1, "M|A"){print $$2}' | grep .go); do \
		DIR="$$(dirname "$${f}")";\
		$(LOCAL_BIN)/golangci-lint run --fix --color=always --timeout 4m $$DIR; \
	done

.PHONY: golint-derefnil
golint-derefnil: ## runs derefnil linter
	$(GO) $(GOFLAG) vet -vettool=$$(which $(LOCAL_BIN)/golint-derefnil) ./...

.PHONY: install-githooks
install-githooks: ## installs all git hooks
	@echo "Installing githooks"
	cp ./githooks/* .git/hooks/

.PHONY: wire
wire: ## injects dependencies
	$(LOCAL_BIN)/wire cmd/tgbot/wire.go 

.PHONY: build
build: wire ## builds all commands
	$(GO) $(GOFLAG) build -o $(LOCAL_BIN)/tgbot ./cmd/tgbot

.PHONY: run
run: build ## builds and runs the polling bot
	$(LOCAL_BIN)/tgbot

.PHONY: test
test: ## runs tests
	@echo "Testing"
	$(GO) $(GOFLAG) test ./...

.PHONY: init-db
init-db: ## initializes db
	$(GO) $(GOFLAG) run migrations/sqlite.go

.PHONY: help
help:
	@grep --no-filename -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
