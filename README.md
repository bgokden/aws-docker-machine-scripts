# aws-docker-machine-scripts
Scripts to build a docker swarm cluster on aws with docker-machine

Occasionaly I need to create a docker swarm cluster with docker engine swarm mode on aws ec2. I have build some scripts to help me do a create a presentation cluster easily.

I have run into some people had problems with creating clusters so I wanted to share this scripts with them.

Just set environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

```
export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???
```

Recommended way of starting my image
Download and run my starting script:

```
wget https://raw.githubusercontent.com/bgokden/aws-docker-machine-scripts/master/run.sh
chmod +x run.sh
./run.sh
```


I hope you use bash

To create a new cluster

```
./createcluster.sh
```

To remove cluster
```
./rmcluster.sh
```


Contact me if you want more info: berkgokden@gmail.com
