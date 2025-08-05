package main

import (
	"log"

	"github.com/apiimperfect/save-api/cmd/api/router"
	"github.com/gin-gonic/gin"
)

// Server represents the main HTTP server instance
// It encapsulates the Gin router and provides methods for server management
type Server struct {
	router *gin.Engine // Gin router instance for handling HTTP requests
}

// NewServer creates and initializes a new server instance
// Returns a configured server with default Gin settings
func NewServer() (*Server, error) {
	// Initialize Gin with default middleware (logger, recovery)
	router := gin.Default()

	// Create and return server instance
	server := &Server{
		router: router,
	}

	return server, nil
}

// SetupRouter configures all application routes
// Delegates route setup to the router package for better organization
func (server *Server) SetupRouter() {
	router.SetupRouter(server.router)
}

// Start begins listening for HTTP requests on the specified address
// This method blocks until the server is stopped
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

// main is the application entry point
// Initializes the server, sets up routes, and starts listening for requests
func main() {
	// Create new server instance
	server, err := NewServer()
	if err != nil {
		log.Fatal(err)
	}

	// Configure all application routes
	server.SetupRouter()

	// Start the server and log the startup message
	log.Println("Server starting on :8080")
	if err := server.Start(":8080"); err != nil {
		log.Fatal(err)
	}
}
