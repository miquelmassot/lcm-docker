# LCM docker image

This repository contains the scripts to build and run the middleware called Lightweight Communications and Marshalling (LCM) as a docker image based on Alpine Linux.

## Usage

Clone this repository on your computer

    git clone git@github.com:miquelmassot/lcm-docker.git

Build the docker image

    cd lcm-docker
    ./build.sh

Run the docker image

    ./run.sh

Alternatively, you can use an alias to run the image from any directory:

    alias lcm-docker='docker run --rm -it --net=host --ipc=private -e USER=$(whoami) -h $HOSTNAME --user $(id -u):$(id -g) --volume $(pwd):/project -w /project --name=lcm_$(whoami)_$(date +%Y%m%d_%H%M%S) miquelmassot/lcm:latest bash'

So that you can use it anywhere:

    cd /your/working/folder
    lcm-docker

This will start an LCM docker image in the current directory - run any commands you need (python, lcm, c++) from within that console from now on to use LCM.
