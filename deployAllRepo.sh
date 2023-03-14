#!/bin/bash

CONFIG_FILE="./.microcfg"
CURRENT_DIR=$(pwd)

source $CONFIG_FILE
prefix="micro-shop"

function build_image() {  
    docker build -t $1:latest -f docker/$2.Dockerfile .
    k3d image import --cluster micro-shop-local $1:latest  
}
prefix="micro-shop"
declare -a gitrepos=("orders" "api" "products" "ui")

for repo in ${gitrepos[@]}; do
    echo    
    cd $MICRO_SERVICE_ROOT    
    echo "${repo}.........................................................."
    if [ -d ${prefix}-${repo} ]; then
        cd ${prefix}-${repo}
        if [ "$(git fetch && git rev-list main...origin/main --count)" -gt "0" ]; then
            echo "Main branch behind origin/main."
            # git checkout main
            # git pull               
            git checkout main
            git pull
            build_image ${repo} ${prefix}-${repo}
        else
            echo "Main branch current or ahead of origin/main."
            build_image ${repo} ${prefix}-${repo}
        fi
  else
    echo "Cloning repo."
    git clone git@github.com:amitsatpute-gslab/${prefix}-${repo}.git
    # git checkout main    
    cd ${prefix}-${repo}
    git checkout dev
    build_image ${repo} ${prefix}-${repo}
  fi

done

cd $CURRENT_DIR