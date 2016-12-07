#!/usr/bin/env bash

#export AWS_ACCESS_KEY_ID=???
#export AWS_SECRET_ACCESS_KEY=???

export VOL="-v ${PWD}/machine:/root/.docker/machine"
export ENV="-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
mkdir -p ${PWD}/machine
docker run -it ${ENV} ${VOL} berkgokden/aws-docker-machine-scripts:0.1 /bin/bash
