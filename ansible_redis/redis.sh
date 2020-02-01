#!/bin/bash

function bake {
    packer build redis.json
}

function run {
    docker run -p 6379:6379 tema17-redis:1
}

function status {
    docker exec -it "$(docker ps --filter ancestor=tema17-redis:1 -q)" ps aux | grep redis
}

function stop {
    docker stop "$(docker ps --filter ancestor=tema17-redis:1 -q)"
}

case $1 in
     "bake")
          bake
          ;;
     "run")
          run
          ;;
     "status")
          status
          ;;
     "stop")
          stop
          ;;
     "*")
          echo "Function not found!"
esac