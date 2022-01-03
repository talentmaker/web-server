# Web server

A simple web server that serves everything [Talentmaker](https://github.com/talentmaker), including the [Site](https://github.com/talentmaker/site), [API](https://github.com/talentmaker/api), and [Rendertron instance](https://github.com/talentmaker/web-server/tree/master/rendertron). Implements dynamic rendering by pre-rendering content with [Rendertron](https://github.com/GoogleChrome/rendertron) and the [Rendertron middleware](https://github.com/talentmaker/rendertronmiddleware) to serve pre-rendered content to crawlers to improve SEO.

## Running

### NGINX

_Note to self: SSL certificates should be in the filesystem_

Link nginx config

```sh
sudo ln -vf nginx.conf /etc/nginx/nginx.conf
```

Run nginx

```sh
sudo nginx -s reload
```

### Docker

Run Docker services

```sh
docker-compose up
```

**Alternatively, with Systemd (oh no)**

Link service file

_Note to self: values are hardcoded, may need to be changed_

```sh
sudo ln -vf talentmaker.service /etc/systemd/system/talentmaker.service
```

Enable and start

```sh
sudo systemctl enable --now
```

### CRON Job

The CRON job runs at 3am EST every day and rebuilds the app if there are changes to the head of the remote repos

```
0 3 * * * /home/ubuntu/Documents/web-server/manager/cron.bash
```

Enable logrotate for log management

```sh
sudo ln -vf logrotate.conf /etc/logrotate.d/talentmaker
```
