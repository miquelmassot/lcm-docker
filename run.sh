#!/bin/bash
#docker run -it --net=host -v $PWD:/project -w /project miquelmassot/lcm:latest

docker run --rm -it --net=host --ipc=private -e USER=$(whoami) -h $HOSTNAME --user $(id -u):$(id -g) --volume $(pwd):/project -w /project --name=lcm_$(whoami)_$(date +%Y%m%d_%H%M%S) miquelmassot/lcm:latest bash
