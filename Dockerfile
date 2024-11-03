ARG GO_VERSION=1
FROM golang:${GO_VERSION}-bookworm as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the Go module files
COPY go.mod go.sum ./

# Download the dependencies
RUN go mod download && go mod verify
# Copy the rest of the application code
COPY . .

# Copy home.html to the desired location in the image
COPY home.html home.html

# Build the application
RUN go build -v -o /run-app .

# Expose the port your application listens on
EXPOSE 8080

# Run the compiled binary
FROM debian:bookworm

COPY --from=builder /run-app /usr/local/bin/
CMD ["run-app"]
