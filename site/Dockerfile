FROM docker.io/golang:1.17.5

RUN apt-get update
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install -y git nodejs

ARG HASH=none
RUN git clone https://github.com/talentmaker/site.git /tmp/talentmaker-site

WORKDIR /tmp/talentmaker-site

RUN npm i -g pnpm
RUN pnpm install
RUN pnpm build

WORKDIR /go/src/github.com/talentmaker/web-server

RUN mkdir ./static
RUN mv /tmp/talentmaker-site/build ./static/site

COPY . .

RUN go get -v ./...
RUN go build main.go

EXPOSE 3000

CMD ["./main"]
