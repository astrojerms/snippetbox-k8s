FROM golang:1.19.2-alpine as build

COPY . .

# Set CGO_ENABLED to 0 to turn off dynamic linking to libc/libmusl
RUN GOPATH=/ CGO_ENABLED=0 go build -o /snippetbox ./cmd/web

FROM scratch

ENV DB_HOST="127.0.0.1:3306"

COPY --from=build /snippetbox /snippetbox
COPY --from=build /go/tls /tls

EXPOSE 4000/tcp

CMD [ "/snippetbox" ]