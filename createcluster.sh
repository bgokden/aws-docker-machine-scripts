#!/usr/bin/env bash
# Print commands
set -x
# Stop on error
set -e

source env.sh

export PORTS="--amazonec2-open-port 2377 --amazonec2-open-port 7946 --amazonec2-open-port 4789 --amazonec2-open-port 7946/udp --amazonec2-open-port 4789/udp --amazonec2-open-port 8080 --amazonec2-open-port 80 --amazonec2-open-port 443"
export CREATE="$DOCKER_MACHINE_EXECUTABLE create --driver amazonec2"
export REMOVE="$DOCKER_MACHINE_EXECUTABLE rm --force"

# this is a workaround for a bug in aws driver
$CREATE $PORTS ports || true
$REMOVE ports || true
# you may use
# aws ec2 authorize-security-group-ingress --group-name docker-machine --protocol -1 --cidr 0.0.0.0/0
# but I don't like opening all the ports to outside.

function createmachine {
   $CREATE $1
   while [ $? -ne 0 ]; do
        $REMOVE $1
        $CREATE $1
   done
}

for i in $(seq 1 $NODENUMBER)
do
   echo "Starting  ${PREFIX}$i"
   createmachine ${PREFIX}$i &
   sleep 2
done

wait

$DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}1 sudo docker swarm init
MANAGERTOKEN=$($DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}1 sudo docker swarm join-token manager -q)
WORKERTOKEN=$($DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}1 sudo docker swarm join-token worker -q)
MASTERNODEIP=$($DOCKER_MACHINE_EXECUTABLE ip ${PREFIX}1)

echo $MANAGERTOKEN > manager.token
echo $WORKERTOKEN > worker.token

for i in $(seq 2 $MANAGERNUMBER)
do
   echo "Adding ${PREFIX}$i as manager"
   $DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}$i sudo docker swarm join \
    --token $MANAGERTOKEN \
    $MASTERNODEIP:2377
done


for i in $(seq $(($MANAGERNUMBER+1)) $NODENUMBER)
do
   echo "Adding ${PREFIX}$i as worker"
   $DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}$i sudo docker swarm join \
    --token $WORKERTOKEN \
    $MASTERNODEIP:2377
done

$DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}1 sudo docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer

$DOCKER_MACHINE_EXECUTABLE ssh ${PREFIX}1 sudo docker network create --driver overlay mynetwork


echo "done"
