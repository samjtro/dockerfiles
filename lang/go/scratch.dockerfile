# BUILD
FROM golang:alpine as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/app

# RUN
FROM scratch
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app/app"]
