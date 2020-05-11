package main

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	currentOperation := false

	r.POST("/start", func(c *gin.Context) {
		currentOperation = true
		time.Sleep(time.Second * 60)
		currentOperation = false
		c.JSON(http.StatusOK, "Completed....")
	})

	r.GET("/upgradeable", func(c *gin.Context) {
		c.JSON(http.StatusOK, map[string]bool{
			"isUpgradeable": !currentOperation,
		})
	})

	r.Run()
}
