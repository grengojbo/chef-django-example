Description
===========

This cookbook is designed to be able to describe and deploy Python web applications. Currently supported:

* plain python web applications
* Django
* Green Unicorn
* Celery

Note that this cookbook provides the Python-specific bindings for the `application` cookbook; you will find general documentation in that cookbook.

Other application stacks may be supported at a later date.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

The following Opscode cookbooks are dependencies:

* application
* python
* gunicorn
* supervisor

Необходимо установить Gem

    gem install ruby-shadow

Resources/Providers
==========

The LWRPs provided by this cookbook are not meant to be used by themselves; make sure you are familiar with the `application` cookbook before proceeding.

django
------

Use knife to create a data bag for users. Используйте **knife**, чтобы создать **data bag** для пользователей.

    knife data bag create users <username>
    # OR
    knife data bag edit users <username>
     ...
     "id": "<username>",
     #"action": "remove", Для удаления
     "nagios": {
     "pager": "8005551212@txt.att.net",
       "email": "bofh@example.com"
     },
     "shell": "/bin/bash",
     "ssh_keys": "ssh-rsa <ssh public key для доступа к акаунту>",
     "uid": <2000>,
     "group": "www-data",
     "home": "/opt/www/<username>",
     "password": "<password>",
     "comment": "Django App"
     ...

Просмотр списка пользователей

    knife data bag show users

Добавляем пользователя на хост

    knife node edit app.example.com
    ...
     "users": [
          "<username>"
     ],
     "run_list": [
        "recipe[user::data_bag]",
        "role[nodes-nodes-<userID>-django-app]",
        "recipe[basics::cleanup]"
     ]
     ...

Добавляем приложение

    knife role edit nodes-<userID>-django-app
    ...
    "override_attributes": {
        "django": {
          "application": "django-app",
          "users": "<username>",
          "repository": "git@github.com:django-app.git"
        }
      },
      "run_list": [
        "recipe[django::default]"
      ],
      ...

Create a user in the data_bag/users/ directory. Создайте пользователя в **data_bag/users/** каталоге.

    knife data bag users <User Name>
    "recipe[django::default]",
    "recipe[user]",
