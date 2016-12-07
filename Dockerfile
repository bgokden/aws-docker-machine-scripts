FROM golang:1.7.3
MAINTAINER Berk Gokden "berkgokden@gmail.com"
#To build: docker build -t berkgokden/aws-docker-machine-scripts:0.1 .

# I need the latest version of docker-machine
RUN go get  github.com/golang/lint/golint \
            github.com/mattn/goveralls \
            golang.org/x/tools/cover

RUN mkdir /root/docker-machine && \
  cd /root/docker-machine && \
  export GOPATH="$PWD" && \
  go get github.com/docker/machine && \
  cd src/github.com/docker/machine && \
  make build && \
  cp bin/docker-machine /usr/local/bin/docker-machine && \
  rm -rf /root/docker-machine

RUN chmod +x /usr/local/bin/docker-machine
# my scripts..
WORKDIR /scripts
ADD env.sh .
ADD createcluster.sh .
ADD rmcluster.sh .
