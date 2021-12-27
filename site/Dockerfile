FROM docker.io/golang:1.17.5

WORKDIR /go/src/github.com/talentmaker/web-server

COPY . .

RUN go get -v ./...
RUN go build main.go

EXPOSE 3000

CMD ["./main"]
