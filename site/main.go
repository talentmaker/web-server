package main

import (
	rendertron "github.com/talentmaker/rendertronmiddleware"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/helmet/v2"
)

func main() {
	app := fiber.New()

	app.Use(helmet.New())

	app.Use(rendertron.New(rendertron.Options{
		ProxyUrl: "http://localhost:8000/render",
		ExtraBotUserAgents: []string{
			"curl",
			"googlebot",
			"bingbot",
			"linkedinbot",
			"mediapartners-google",
		},
	}))

	app.Static("/", "./static/site")

	app.Get("*", func(ctx *fiber.Ctx) error {
		return ctx.SendFile("./static/site/index.html")
	})

	app.Listen(":3000")
}
