#!/usr/bin/env bash
# Print commands
set -x
# Stop on error
set -e

source env.sh

export DOCKER_MACHINE_EXECUTABLE="docker-machine"

$DOCKER_MACHINE_EXECUTABLE rm --force $($DOCKER_MACHINE_EXECUTABLE ls -q)

echo "done"
