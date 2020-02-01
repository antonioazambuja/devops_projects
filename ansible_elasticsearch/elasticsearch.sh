#!/bin/bash

function bake {
    packer build elasticsearch.json
}

function run {
    docker run -p 9200:9200 -p 9300:9300 tema17-elasticsearch:1
}

function status {
    curl http://localhost:9200
}

function stop {
    docker stop "$(docker ps --filter ancestor=tema17-elasticsearch:1 -q)"
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