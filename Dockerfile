#---------- Build Stage ----------
FROM golang:1.23-alpine AS build

WORKDIR /app

# Copy and download dependencies
COPY go.mod ./
RUN go mod download

# Copy all files
COPY . .

# Build the Go binary
RUN go build -o app-built main.go

#---------- Run Stage ----------
FROM alpine:latest

WORKDIR /root/

# Copy binary from build stage
COPY --from=build /app/app-built .
COPY --from=build /app/static ./static

# Expose the port
EXPOSE 8080

# Command to run
CMD ["./app-built"]
