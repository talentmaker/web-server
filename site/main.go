package main

import (
	"time"

	rendertron "github.com/talentmaker/rendertronmiddleware"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/helmet/v2"
)

func main() {
	app := fiber.New()

	app.Use(
		helmet.New(),
		limiter.New(limiter.Config{
			Max:        100,
			Expiration: 1 * time.Minute,
			KeyGenerator: func(ctx *fiber.Ctx) string {
				return ctx.IP()
			},
			LimitReached: func(ctx *fiber.Ctx) error {
				return ctx.Status(429).SendString("Too many requests")
			},
		}),
		compress.New(compress.Config{
			Level: compress.LevelBestSpeed,
		}),
	)

	app.Use(func(ctx *fiber.Ctx) error {
		ctx.Request().Header.Add("X-Forwarded-Host", "talentmaker.ca")

		return ctx.Next()
	})

	app.Use(rendertron.New(rendertron.Options{
		ProxyUrl: "http://localhost:8000/render",
		ExtraBotUserAgents: []string{
			"curl",
			"googlebot",
			"bingbot",
			"linkedinbot",
			"mediapartners-google",
		},
		AllowedForwardedHosts: []string{"talentmaker.ca"},
		ForceHTTPS:            true,
	}))

	app.Static("/static", "./static/site/static", fiber.Static{
		Compress: true,
		MaxAge:   2_592_000, // 30 Days
	})

	app.Static("/", "./static/site", fiber.Static{
		Compress: true,
	})

	app.Get("*", func(ctx *fiber.Ctx) error {
		return ctx.SendFile("./static/site/index.html")
	})

	app.Listen(":3000")
}
