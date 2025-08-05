GOLANG := golang:1.24.2

tidy:
	go mod tidy
	go mod vendor

.PHONY: tidy