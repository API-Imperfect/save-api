package router

import (
	"github.com/gin-gonic/gin"
)

// SetupRouter configures all routes for the application
func SetupRouter(router *gin.Engine) {
	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": "ok",
		})
	})

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Add your API routes here
		v1.GET("/", func(c *gin.Context) {
			c.JSON(200, gin.H{
				"message": "Welcome to Save API v1",
			})
		})
	}
}
