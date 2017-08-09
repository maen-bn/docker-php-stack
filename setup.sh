#! /usr/bin/env bash

replace_env_variable(){
    sed -i "s~^${1}=.*$~${1}=${2}~" .env
}

if [ ! -f ./.env ]
then

    # Copy example env file
    cp ./.env.example ./.env

    # Get the host path for the app
    read -p "Specify the host path to your app: " host_path_app
    host_path_app=$(dirname $(readlink -e ${host_path_app}))/$(basename ${host_path_app})
    echo "Your app directory is: ${host_path_app}"
    replace_env_variable "HOST_PATH_TO_APP" $host_path_app

    # Get the name the user wants for the MySQL DB name
    read -p "What should your MySQL DB be called? " mysql_db_name
    replace_env_variable "MYSQL_DATABASE" $mysql_db_name

    # Get the name the user wants for the MySQL DB name
    read -p "What should your MySQL user be called? " mysql_db_user
    replace_env_variable "MYSQL_USER" $mysql_db_user

    # Get the name the user wants for the MySQL DB name
    read -p "What should the password be for the MySQL user '${mysql_db_user}'? " mysql_db_password
    sed -i "s~^MYSQL_PASSWORD=.*$~MYSQL_PASSWORD=${mysql_db_password}~" .env
    replace_env_variable "MYSQL_PASSWORD" $mysql_db_password

    echo "Do you wish to install this program?"
    select node_environment in "production" "staging" "testing" "development";
    do
        case $node_environment in
            "production"|"staging"|"testing"|"development") replace_env_variable "NODE_ENV" $node_environment .env; break;;
            * ) echo "That environment is not valid. EXITING"; rm ./.env; exit;;
        esac
    done
fi

echo "Building images ... "
docker-compose build >/dev/null 2>&1
echo "Images are all built. elephant-whale is available from you app directory now"