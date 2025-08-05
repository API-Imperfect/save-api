GOLANG := golang:1.24.2

.PHONY: tidy

tidy:
	go mod tidy
	go mod vendor

