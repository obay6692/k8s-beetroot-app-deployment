# Stage 1: Build stage
FROM golang:alpine AS build

# Set the working directory
WORKDIR /app

# Copy and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . .

# Set the working directory
WORKDIR /app/cmd/beetroot

# Add dependencies & Build the Go application
RUN go get && \
    go build -o myapp .

# Stage 2: Final stage
FROM alpine:edge

# Set the working directory
WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /app/cmd/beetroot/myapp .

# Install the timezone package
RUN apk --no-cache add tzdata

# Set the timezone
ENV TZ=Europe/Oslo

# Set the entrypoint command
ENTRYPOINT ["/app/myapp"]
