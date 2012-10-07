#
# Cookbook Name:: mongodb
# Attributes:: default
#
# Copyright 2010, edelight GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:django][:base_packages] = %w(git-core bash-completion nmap libshadow-ruby1.8)
default[:django][:ubuntu_python_packages] = %w(python-setuptools python-pip python-dev libpq-dev)
default[:django][:application] = "my-app"
default[:django][:users] = "djangoapp"
default[:django][:groups] = "www-data"
default[:django][:homedir] = "/opt"
default[:django][:repository] = "https://github.com/coderanger/packaginator.git"
default[:django][:revision] = "master"
default[:django][:apps] = "kvazar"
