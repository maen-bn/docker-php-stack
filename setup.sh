#! /usr/bin/env bash

get_env_variable(){
    echo $(sed -n -e "/${1}/ s/.*\= *//p" .env)
}

replace_env_variable(){
    sed -i "s~^${1}=.*$~${1}=${2}~" .env
}
echo -e "$(tput bold)$(tput setab 4)                                   $(tput sgr0)"
echo -e "$(tput bold)$(tput setab 4)     Welcome to elephant-whale     $(tput sgr0)"
echo -e "$(tput bold)$(tput setab 4)                                   $(tput sgr0)"
#echo -e "$(tput bold)Welcome to elephant-whale$(tput sgr0)"

#read -p "$(tput bold)$(tput setaf 3)HELLO TEST$(tput sgr0)" test


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
    read -p "$(tput bold)$(tput setaf 3)Specify the host path to your app:$(tput sgr0) " host_path_app
    host_path_app=$(dirname $(readlink -e ${host_path_app}))/$(basename ${host_path_app})

    printf '\n'
    echo "$(tput bold)$(tput setaf 2)Your app directory is:${host_path_app}$(tput sgr0) "
    printf '\n'
    replace_env_variable "HOST_PATH_TO_APP" $host_path_app

    # Let user specify where this is being ran

    echo "$(tput bold)$(tput setaf 3)What sort of environment are running this in?$(tput sgr0) "
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
    printf '\n'

    # Get the PHP version the user wants
    echo "$(tput bold)$(tput setaf 3)Select a PHP version:$(tput sgr0) "
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
    printf '\n'

     # Get the PHP version the user wants
    echo "$(tput bold)$(tput setaf 3)Select a MySQL/Maria DB version:$(tput sgr0) "
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
    printf '\n'

    if [ ! $mysql_version_number == "" ]; then
        replace_env_variable "MYSQL_VERSION" $mysql_version_number .env;
    fi

    if [ !  -d "${host_path_app}/data/mysql${mysql_version_number}"   ] ; then
        # Get the name the user wants for the MySQL DB name
        read -p "$(tput bold)$(tput setaf 3)What should your MySQL DB be called?$(tput sgr0) " mysql_db_name
        replace_env_variable "MYSQL_DATABASE" $mysql_db_name
        printf '\n'

        # Get the name the user wants for the MySQL DB name
        read -p "$(tput bold)$(tput setaf 3)What should your MySQL user be called?$(tput sgr0) " mysql_user
        replace_env_variable "MYSQL_USER" $mysql_user
        printf '\n'

        # Get the name the user wants for the MySQL DB name
        read -p "$(tput bold)$(tput setaf 3)What should the password be for the MySQL user '${mysql_user}'?$(tput sgr0) " mysql_password
        replace_env_variable "MYSQL_PASSWORD" $mysql_password
        printf '\n'

        # Get the name the user wants for the MySQL DB name
        read -p "$(tput bold)$(tput setaf 3)What should the password be for the MySQL root user?$(tput sgr0) " mysql_root_password
        replace_env_variable "MYSQL_ROOT_PASSWORD" $mysql_root_password
        printf '\n'
    fi
fi


echo "$(tput bold)$(tput setaf 2)Building images ... $(tput sgr0)"
docker-compose build
echo "$(tput bold)$(tput setaf 2)Images are all built. Now run 'docker-compose up -d' to bring up your containers $(tput sgr0)"