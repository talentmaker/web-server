# Web server

A simple web server that serves everything [Talentmaker](https://github.com/talentmaker), including the [Site](https://github.com/talentmaker/site), [API](https://github.com/talentmaker/api), and [Rendertron instance](https://github.com/talentmaker/web-server/rendertron). Implements dynamic rendering by pre-rendering content with [Rendertron](https://github.com/GoogleChrome/rendertron) and the [Rendertron middleware](https://github.com/talentmaker/rendertronmiddleware) to serve pre-rendered content to crawlers to improve SEO.

## Running

Link nginx config

```sh
sudo ln nginx.conf /etc/nginx/conf.d/default.conf
```

Run nginx

```sh
sudo nginx -s reload
```

Run Docker services

```sh
docker-compose up
```
