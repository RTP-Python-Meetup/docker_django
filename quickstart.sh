#!/bin/sh

pipenv install django gunicorn --python 3

#while [ 1 ]
#do
#  printf '\n\nProject name: '
#  read -r project_name
#
#  [ -d "$project_name" ] || break
#  printf "The directory \"$project_name\" already exists.\n"
#done
project_name="django_docker"

#pipenv run django-admin startproject "$project_name"
cd "$project_name" || exit
pipenv run python manage.py makemigrations
pipenv run python manage.py migrate
#pipenv run python manage.py createsuperuser

printf 'Updating settings.py\n'
if ! grep -q 'import os' $project_name/settings.py
then
  sed -Ei '0,/.*import.+/ s/(.*import.+)/import os\n\1/g' $project_name/settings.py
fi

sed -Ei 's/^(DEBUG = )True$/\1int(os.environ.get("DEBUG", 1))/g' $project_name/settings.py

printf 'Creating .env\n'
printf 'DEBUG=1\n' > .env

#pipenv run gunicorn django_docker.wsgi:application --bind 0.0.0.0:8000
