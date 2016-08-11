#!/bin/bash

declare -a repos
declare -a workdirs

repos=(
appzipper
configmanager
credentialsmanager
dbconnector
dbmanager
descriptionxml
devicemanager
licensemanager
organizationmanager
servicemanager
sqlalchemymodels
)

workdirs=(
appcloud
services
)

echo "Creating directories to store Zato services and server objects..."
for dir in ${workdirs[@]}
do
    if [ ! -d $HOME/$dir ]
    then
        mkdir $HOME/$dir
        echo "Directory $dir created."
    fi
done
cd $HOME/appcloud

echo "Cloning repositories and copying services..."
for repo in ${repos[@]}
do
    if [ ! -d appcloud.$repo ]
    then
        git clone git@bitbucket.org:foxway/appcloud.$repo.git
        cd appcloud.$repo
        cp ./*.py $HOME/services
        if [ -f ./*ops ]
        then
            cp ./*ops $HOME/services
        fi
        cd ..
    fi
done
