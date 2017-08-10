#! /usr/bin/env bash

replace_env_variable(){
    sed -i "s~^${1}=.*$~${1}=${2}~" .env
}

if [ ! -f ./.env ] || [ $1 == "fresh" ]
then

    # Copy example env file
    cp ./.env.example ./.env

    # Get the host path for the app
    read -p "Specify the host path to your app: " host_path_app
    host_path_app=$(dirname $(readlink -e ${host_path_app}))/$(basename ${host_path_app})
    echo "Your app directory is: ${host_path_app}"
    replace_env_variable "HOST_PATH_TO_APP" $host_path_app

    # Get the PHP version the user wants
    echo "Select a PHP version"
    select php_version in "7.1" "5.6";
    do
        case $php_version in
            "7.1") break;;
            "5.6")
                replace_env_variable "PHP_VERSION" "56" .env;
                replace_env_variable "PHP_IMAGE_TAG" "56" .env;
                break;;
            * ) echo "Invalid selection. EXITING"; rm ./.env; exit;;
        esac
    done

     # Get the PHP version the user wants
    echo "Select a MySQL/Maria DB version"
    select php_version in "Maria DB 10.1" "MySQL 5.7";
    do
        case $php_version in
            "Maria DB 10.1") break;;
            "MySQL 5.7")
                replace_env_variable "MYSQL_VERSION" "57" .env;
                break;;
            * ) echo "Invalid selection. EXITING"; rm ./.env; exit;;
        esac
    done

    # Get the name the user wants for the MySQL DB name
    read -p "What should your MySQL DB be called? " mysql_db_name
    replace_env_variable "MYSQL_DATABASE" $mysql_db_name

    # Get the name the user wants for the MySQL DB name
    read -p "What should your MySQL user be called? " mysql_user
    replace_env_variable "MYSQL_USER" $mysql_user

    # Get the name the user wants for the MySQL DB name
    read -p "What should the password be for the MySQL user '${mysql_user}'? " mysql_password
    replace_env_variable "MYSQL_PASSWORD" $mysql_password

    # Get the name the user wants for the MySQL DB name
    read -p "What should the password be for the MySQL root user? " mysql_root_password
    replace_env_variable "MYSQL_ROOT_PASSWORD" $mysql_root_password

    echo "Select a node environment?"
    select node_environment in "production" "staging" "testing" "development";
    do
        case $node_environment in
            "production"|"staging"|"testing"|"development") replace_env_variable "NODE_ENV" $node_environment .env; break;;
            * ) echo "Invalid selection. EXITING"; rm ./.env; exit;;
        esac
    done
fi

echo "Building images ... "
docker-compose build
echo "Images are all built. elephant-whale is available from you app directory now"