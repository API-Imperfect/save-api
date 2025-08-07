GOLANG := golang:1.24.2

.PHONY: tidy migrate-up migrate-down migrate-create migrate-force migrate-reset confirm

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
migrate-create: confirm
	@echo "Creating migration files for ${name}..."
	migrate create -ext sql -dir ./internal/db/migrations -seq ${name}

# Run migrations up
# set -a and set +a are used to source the dev.env file and set the DB_SOURCE variable in the environment.
# This is necessary because the migrate command does not support passing environment variables directly.
# Usage: 
#   make migrate-up              - runs all pending migrations
#   make migrate-up version=1    - runs migrations up to specific version
migrate-up: confirm
	@echo "Running migrations up"
	@if [ -n "$(version)" ]; then \
		echo "Applying migrations up to version: $(version)"; \
		set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" goto $(version); \
	else \
		echo "Applying all pending migrations"; \
		set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" up; \
	fi

# Run migrations down
# Usage:
#   make migrate-down            - rolls back all migrations
#   make migrate-down version=0  - rolls back to specific version
migrate-down: confirm
	@echo "Running migrations down"
	@if [ -n "$(version)" ]; then \
		echo "Rolling back to version: $(version)"; \
		set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" goto $(version); \
	else \
		echo "Rolling back all migrations"; \
		set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" down; \
	fi

# Force migration version (useful for fixing dirty database)
# Usage: make migrate-force version=1
migrate-force: confirm
	@echo "Forcing migration version ${version}"
	@set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" force ${version}

# Reset migrations (drop all tables and re-run from beginning)
migrate-reset: confirm
	@echo "Resetting all migrations"
	@set -a && . ./dev.env && set +a && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" drop && migrate -path ./internal/db/migrations -database "$$DB_SOURCE" up

tidy:
	@echo 'Tidying module dependencies...'
	go mod tidy
	@echo 'Verifying and vendoring module dependencies...'
	go mod verify
	go mod vendor

