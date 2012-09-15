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

Resources/Providers
==========

The LWRPs provided by this cookbook are not meant to be used by themselves; make sure you are familiar with the `application` cookbook before proceeding.

django
------
