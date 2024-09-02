# Stage 1: Create index.html
FROM alpine:3.19 AS builder

# Install necessary tools
RUN apk --no-cache add bash

# Create a directory for the index.html file
RUN mkdir -p /html

# Create index.html in the new directory
RUN echo '<p>Hello World</p>' > /html/index.html

# Stage 2: Nginx setup
FROM nginx:alpine

# Copy the index.html from the previous stage
COPY --from=builder /html/index.html /usr/share/nginx/html/index.html

# Print a message and start nginx in the foreground
CMD echo "starting nginx" && nginx -g 'daemon off;'

