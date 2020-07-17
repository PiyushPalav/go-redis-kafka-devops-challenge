FROM golang:alpine

#Install bash for alpine images
RUN apk add --no-cache bash

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=1 \
    GOOS=linux \
    GOARCH=amd64

# Create working directory /my-go-app
RUN mkdir /my-go-app

# Move to working directory /my-go-app
WORKDIR /my-go-app

#Copy code files in the newly created directory
COPY . .

#Add executable permissions to the start shell script
RUN chmod +x start.sh

#Execute the start script as the container starts
ENTRYPOINT ["./start.sh"]