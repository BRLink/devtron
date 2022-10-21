################################# Build Container ###############################

FROM golang:1.16@sha256:5f6a4662de3efc6d6bb812d02e9de3d8698eea16b8eb7281f03e6f3e8383018e as builder

# Setup the working directory
WORKDIR /app

# COPY go module
COPY go.mod go.sum /app/

# Download go modules and cache for next time build
RUN go mod download

# Add source code
ADD . /app/

# Build the source
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main app.go


################################# Prod Container #################################

# Use a minimal alpine image
FROM alpine:3.7@sha256:8421d9a84432575381bfabd248f1eb56f3aa21d9d7cd2511583c68c9b7511d10

# Add ca-certificates in case you need them
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /root

# Copy the binary from builder
COPY --from=builder /app/main .

# Run the binary
CMD ["./main"]