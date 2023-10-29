TARGET_LIST=$(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')
.PHONY: $(TARGET_LIST)
.SILENT: $(TARGET_LIST)

CTN_APP := app # コンテナ名（アプリ）
CTN_DB := app_db # コンテナ名（DB）

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## docker-compose build --no-cache
	@docker-compose build --no-cache

up-all-build: ## docker-compose up --build
	@docker-compose up --build

up-all-build-d: ## docker-compose up --build -d
	@docker-compose up --build -d

up-all: ## docker-compose up
	@docker-compose up

up-all-d: ## docker-compose up -d
	@docker-compose up -d

up-app-build: ## docker-compose up --build app
	@docker-compose up --build $(CTN_APP)

up-app: ## docker-compose up app
	@docker-compose up $(CTN_APP)

down: ## docker-compose down
	@docker-compose down

down-app: ## docker-compose down app
	@docker-compose down $(CTN_APP)

rm-app:## docker-compose rm -fsv app
	@docker-compose rm -fsv $(CTN_APP)

rm-db:## docker-compose rm -fsv app_db
	@docker-compose rm -fsv $(CTN_DB)

bash-app: ## docker-compose run --rm app /bin/bash
	@docker-compose run --rm $(CTN_APP) /bin/bash

bash-db: ## docker-compose run --rm app_db /bin/bash
	@docker-compose run --rm $(CTN_DB) /bin/bash

exec-bash-app: ## docker-compose exec app /bin/bash
	@docker-compose exec $(CTN_APP) /bin/bash

exec-bash-db: ## docker-compose exec app_db /bin/bash
	@docker-compose exec $(CTN_DB) /bin/bash

db-create: ## rails db:create
	@docker-compose run --rm $(CTN_APP) rails db:create

migrate: ## rails db:migrate
	@docker-compose run --rm $(CTN_APP) rails db:migrate
