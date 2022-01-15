FROM docker.io/golang:1.17.5

RUN apt-get update
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install -y git nodejs
RUN npm i -g pnpm

WORKDIR /go/src/github.com/talentmaker/web-server

COPY . .

RUN go get -v ./...
RUN go build main.go
RUN mkdir ./static

WORKDIR /

ARG SITE_HASH=none
RUN git clone https://github.com/talentmaker/site.git /tmp/talentmaker-site

WORKDIR /tmp/talentmaker-site

RUN pnpm install
RUN pnpm build

WORKDIR /go/src/github.com/talentmaker/web-server

RUN mv /tmp/talentmaker-site/build ./static/site

EXPOSE 3000

CMD ["./main"]
