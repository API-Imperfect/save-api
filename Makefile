include dev.env
export

GOLANG := golang:1.24.2

.PHONY: tidy migrate-up migrate-down create-migration migrate-force migrate-reset confirm docker-build docker-down docker-up build/api

# Confirmation prompt
# Essentially, what happens here is that we ask the user Are you sure? [y/N] and then read the response. We
# then use the code [ $${ans:-N} = y ] to evaluate the response — this will return true if
# the user enters y and false if they enter anything else. If a command in a makefile returns
# false, then make will stop running the rule and exit with an error message — essentially stopping the rule in its tracks.
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

# Create a new migration file
# Usage:
#   make migrate-create name=add_user_locations_table
create-migration: confirm
	@echo "Creating migration files for ${name}..."
	migrate create -ext sql -dir ./internal/data/migrations -seq ${name}

# Run migrations up
# Usage: 
#   make migrate-up              - runs all pending migrations
#   make migrate-up version=1    - runs migrations up to specific version
migrate-up: confirm
	@echo "Running migrations up"
	@if [ -n "$(version)" ]; then \
		echo "Applying migrations up to version: $(version)"; \
		migrate -path ./internal/data/migrations -database "${DB_SOURCE}" goto $(version); \
	else \
		echo "Applying all pending migrations"; \
		migrate -path ./internal/data/migrations -database "${DB_SOURCE}" up; \
	fi

# Run migrations down
# Usage:
#   make migrate-down            - rolls back all migrations
#   make migrate-down version=0  - rolls back to specific version
migrate-down: confirm
	@echo "Running migrations down"
	@if [ -n "$(version)" ]; then \
		echo "Rolling back to version: $(version)"; \
		migrate -path ./internal/data/migrations -database "${DB_SOURCE}" goto $(version); \
	else \
		echo "Rolling back all migrations"; \
		migrate -path ./internal/data/migrations -database "${DB_SOURCE}" down; \
	fi

# Force migration version (useful for fixing dirty database)
# Usage: make migrate-force version=1
migrate-force: confirm
	@echo "Forcing migration version ${version}"
	@migrate -path ./internal/data/migrations -database "${DB_SOURCE}" force ${version}

# Reset migrations (drop all tables and re-run from beginning)
migrate-reset: confirm
	@echo "Resetting all migrations"
	@migrate -path ./internal/data/migrations -database "${DB_SOURCE}" drop && migrate -path ./internal/data/migrations -database "${DB_SOURCE}" up

generate: gen-users

gen-users:
	@echo "Generating SQLC code for users"
	sqlc generate --file ./internal/data/users/sqlc.yml

docker-build:
	@echo "Building the docker image"
	docker compose -f docker/local/local.yml up --build -d

docker-down:
	@echo "Stopping and removing the docker container"
	docker compose -f docker/local/local.yml down

docker-up:
	@echo "Starting the docker container"
	docker compose -f docker/local/local.yml up -d


tidy:
	@echo 'Tidying module dependencies...'
	go mod tidy
	@echo 'Verifying module dependencies...'
	go mod verify
	@echo 'Creating vendor directory with dependencies...'
	go mod vendor

build/api:
	@echo 'Building cmd/api...'
	go build -ldflags='-s' -o=./bin/api ./cmd/api
	GOOS=linux GOARCH=amd64 go build -ldflags='-s' -o=./bin/linux_amd64/api ./cmd/api