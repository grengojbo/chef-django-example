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

## Django

Используйте **knife**, чтобы создать **data bag** для пользователей.

    knife data bag create users <username>
    # OR
    knife data bag edit users <username>
    # OR
    knife data bag from file users data_bags/django-users.json
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

    $ knife data bag show users

Создайте Приложение в **data_bag/apps/** каталоге.

    $ knife data bag edit apps kvazar-app

    "port": 8000,
    "type": "django",
    "databases": {
        "production": {
            "encoding": "utf8",
            "port": "3306",
            "engine": "mysql",
            "database": "db_name_production",
            "username": "db_user",
            "adapter": "mysql",
            "password": "awesome_password"
        },
        "dev": {
            "encoding": "utf8",
            "port": "3306",
            "engine": "mysql",
            "database": "db_name_developer",
            "username": "db_user",
            "adapter": "mysql",
            "password": "awesome_password"
        }
    },
    "repository": "git@github.com:django-app.git",
    "id": "django-app",
    "manage_py_migration_commands": [
        "compilemessages",
        "syncdb --noinput --migrate"
    ],
    "base_django_app_path": "DjangoApp",
    "revision": "master",
    "ipaddress": "127.0.0.1",
    "status": "enable", # enable, disable, remove
    "user": "<username>"

Добавляем пользователя на хост

    $ knife node edit app.example.com
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

затем добавляем Приложение на Сервер Приложений

    knife role edit nodes-<nodeID>-django-app
    ...
    "override_attributes": {
        "mysql": {
          "type": "mysql"
        },
        "django": {
          "apps": [
            "<name>-app",
            "django-app"
          ]
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

Прописываем Имя приложения для которого создается База  mysql/apps/<name>-app

    knife role edit database_master_app<ServerID>
    ...
    "override_attributes": {
        "mysql": {
            "apps": [
                "<name>-app",
                "django-app"
            ]
        }
      },
    "run_list": [
      "recipe[mysql::users]"
    ],
    ...


## Неработает

При добавлении роли "recipe\[mysql::client\]" она сейчас только ResHat