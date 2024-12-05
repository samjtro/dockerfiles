# WIP: NOT WORKING ATM
# BUILD

FROM golang:alpine as builder

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x

ENV GOCACHE=/root/.cache/go-build

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target="/root/.cache/go-build" \
    --mount=type=bind,target=. \
    go build -o app

# RUN

FROM scratch
RUN mkdir /app
WORKDIR /app
COPY --from=builder /app .

# EXPOSE 8080

CMD ["./app/app"]
