#! /usr/bin/env bash

get_env_variable(){
    echo $(sed -n -e "/${1}/ s/.*\= *//p" .env)
}

replace_env_variable(){
    sed -i "s~^${1}=.*$~${1}=${2}~" .env
}

if [ ! -f ./.env ] || [ $1 == "fresh" ]
then

    if [ ! -f ./.env ]; then
        cp ./.env.example ./.env
    fi

    if [ -f ./docker-compose.override.yml ]
    then
        rm ./docker-compose.override.yml
    fi

    # Get the host path for the app
    read -p "Specify the host path to your app: " host_path_app
    host_path_app=$(dirname $(readlink -e ${host_path_app}))/$(basename ${host_path_app})
    echo "Your app directory is: ${host_path_app}"
    replace_env_variable "HOST_PATH_TO_APP" $host_path_app

    # Let user specify where this is being ran

    echo "What sort of environment are running this in?"
    select environment in "production" "staging" "testing" "development";
    do
        case $environment in
            "production"|"staging"|"testing"|"development")
            replace_env_variable "APP_ENV" $environment .env;
            break;;
            * ) echo "Invalid selection. EXITING"; rm ./.env; exit;;
        esac
    done
    if [ $environment != "production" ]
        then
            cp ./docker-compose.dev.yml ./docker-compose.override.yml
    fi


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
    select mysql_version in "Maria DB 10.1" "MySQL 5.7";
    do
        mysql_version_number=""
        case $mysql_version in
            "Maria DB 10.1")break;;
            "MySQL 5.7")
                mysql_version_number="57";
                break;;
            * ) echo "Invalid selection. EXITING"; rm ./.env; exit;;
        esac
    done

    if [ ! $mysql_version_number == "" ]; then
        replace_env_variable "MYSQL_VERSION" $mysql_version_number .env;
    fi

    if [ !  -d "${host_path_app}/data/mysql${mysql_version_number}"   ] ; then
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
    fi
fi


echo "Building images ... "
docker-compose build
echo "Images are all built. Now run docker-compose up to bring up your containers"