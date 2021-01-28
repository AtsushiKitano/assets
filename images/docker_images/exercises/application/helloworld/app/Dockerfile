FROM golang

RUN mkdir app
WORKDIR app

COPY ./main.go .

RUN go build main.go
CMD ["/go/app/main"]
