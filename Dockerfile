# syntax=docker/dockerfile:experimental

FROM golang AS build

ENV GO111MODULE=on
WORKDIR /app

# copy source
COPY go.mod go.sum main.go ./
COPY cmd ./cmd

# build the executable (w/cache hints)
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

# create super thin container with the binary only
FROM scratch
COPY --from=build /app/terragrunt-atlantis-config /app/terragrunt-atlantis-config
ENTRYPOINT [ "/app/terragrunt-atlantis-config" ]
