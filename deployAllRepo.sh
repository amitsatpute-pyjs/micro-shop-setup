#!/bin/bash

CONFIG_FILE="./.microcfg"
CURRENT_DIR=$(pwd)

source $CONFIG_FILE

function build_image() {  
    docker build -t $1:latest -f docker/$1.Dockerfile .
    k3d image import --cluster micro-shop-local $1:latest  
}

declare -a gitrepos=("micro-shop-orders")

for repo in ${gitrepos[@]}; do
    echo    
    cd $MICRO_SERVICE_ROOT    
    echo "${repo}.........................................................."
    if [ -d ${repo} ]; then
        cd ${repo}
        if [ "$(git fetch && git rev-list main...origin/main --count)" -gt "0" ]; then
            echo "Main branch behind origin/main."
            # git checkout main
            # git pull               
            git checkout main
            git pull
            build_image ${repo}      
        else
            echo "Main branch current or ahead of origin/main."
            build_image ${repo}
        fi
  else
    echo "Cloning repo."
    git clone git@github.com:amitsatpute-gslab/${repo}.git
    # git checkout main    
    cd ${repo}
    git checkout dev
    build_image ${repo}    
  fi

done

cd $CURRENT_DIR