package main

import (
	"log"

	"github.com/apiimperfect/save-api/cmd/api/router"
	"github.com/gin-gonic/gin"
)

type Server struct {
	router *gin.Engine
}

func NewServer() (*Server, error) {
	router := gin.Default()

	server := &Server{
		router: router,
	}

	return server, nil
}

func (server *Server) SetupRouter() {
	router.SetupRouter(server.router)
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func main() {
	server, err := NewServer()
	if err != nil {
		log.Fatal(err)
	}

	server.SetupRouter()

	log.Println("Server starting on :8080")
	if err := server.Start(":8080"); err != nil {
		log.Fatal(err)
	}
}
