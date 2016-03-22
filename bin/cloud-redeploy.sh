#!/bin/bash

set -x

. ./bin/common.sh
. ./bin/cloud-common.sh

eval $(docker-machine env "$NAME_REMOTE")
docker-compose -f ./config/jenkins/cluster.yml pull
docker-compose -f ./config/jenkins/cluster.yml down
docker-compose -f ./config/jenkins/cluster.yml up -d

. ./bin/secrets/init-credentials.sh

# remove non-running containers (if they are running this command gives an error)
# --no-trunc prevents id collisions by showing the complete field. -a shows all
# containers, not only running ones. -q only outputs the numeric id field
docker rm $(docker ps --no-trunc -aq)
docker rmi $(docker images --filter dangling=true --quiet)
docker volume rm $(docker volume ls -qf dangling=true)
