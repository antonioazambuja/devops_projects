#!/bin/bash

function bake {
    packer build kafka.json
}

function run {
    docker run -p 2181:2181 -p 9092:9092 tema17-kafka:1
}

function status {
    docker exec -it "$(docker ps --filter ancestor=tema17-kafka:1 -q)" netstat -tlpn | grep -E "2181|9092"
}

function stop {
    docker stop "$(docker ps --filter ancestor=tema17-kafka:1 -q)"
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