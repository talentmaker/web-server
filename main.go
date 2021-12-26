package main

import "github.com/gofiber/fiber/v2"

func main() {
	app := fiber.New()

	app.Static("/", "static/site")

	app.Get("*", func(c *fiber.Ctx) error {
		return c.SendFile("static/site/index.html")
	})

	app.Listen(":3000")
}
