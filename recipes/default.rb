#
# Basic server config: basic users, packages, etc.
#
node[:django][:base_packages].each do |pkg|
    package pkg do
        :upgrade
    end
end
### Packages
# Just base packages required by the whole system here, please. Dependencies
# for other recipes should live int hose recipes.

### Users/groups

# Does the following setup for each user defined in node.json:
#   - creates a group and user paid with a matching uid/guid
#   - creates the home directory
#   - keys the user using a key from the config.
#
# Then creates a group for each group defined in the JSON.


#if node.attribute?("all_servers")
#  template "/etc/hosts" do
#    source "hosts"
#    mode 644
#    variables :all_servers => node[:all_servers] || {}
#  end
#end

#node[:users].each_pair do |username, info|
#    group username do
#       gid info[:id]
#    end
#
#    user username do
#        comment info[:full_name]
#        uid info[:id]
#        gid info[:id]
#        shell info[:disabled] ? "/sbin/nologin" : "/bin/bash"
#        supports :manage_home => true
#        home "/home/#{username}"
#    end
#
#    directory "/home/#{username}/.ssh" do
#        owner username
#        group username
#        mode 0700
#    end
#
#    file "/home/#{username}/.ssh/authorized_keys" do
#        owner username
#        group username
#        mode 0600
#        content info[:key]
#    end
#end
#
#node[:groups].each_pair do |name, info|
#    group name do
Chef::Log.info("################### Django #####################")
search(:users, "id:#{node['django']['users']}") do |u|
  username = u['username'] || u['id']
  Chef::Log.info("Username: #{username} Home Dir: #{u['home']}")

  application node[:django][:application] do
    path "#{node[:django][:homedir]}/#{node[:django][:users]}/#{node[:django][:application]}"
    #owner id
    #group id
    owner node[:django][:users]
    group node[:django][:users]
    repository node[:django][:repository]
    revision node[:django][:revision]
    enable_submodules true
    #action :force_deploy
    force true
    #migrate true
    packages ["git-core", "mercurial", "python-pysqlite2", "python-virtualenv", "virtualenvwrapper"]
    deploy_key ::File.open("/opt/djangotest/.ssh/id_dsa", "r") { |file| file.read }

    django do
      packages ["redis"]
      #deploy_to "/opt/djangotest/django-app/releases"
      requirements "#{node[:django][:homedir]}/#{node[:django][:users]}/#{node[:django][:application]}/shared/cached-copy/requirements/dev.txt"
      #requirements "requirements/dev.txt"
      #local_settings_file "local.py"
      local_settings_file "settings/local.py"
      base_django_app_path "kvazar"
      #settings_template "settings.py.erb"
      settings_template "local-dist.py.erb"
      debug true
      #collectstatic "build_static --noinput"
      database do
        database "packaginator"
        engine "sqlite3"
        adapter "sqlite3"
        username "packaginator"
        password "awesome_password"
      end
      database_master_role "packaginator_database_master"
    end

    gunicorn do
      #only_if { node['roles'].include? 'packaginator_application_server' }
      app_module :django
      port 8080
    end
  end

#bag = node['user']['data_bag_name']
#u = data_bag_item(bag, "username:#{node[:django][:users]}")
#search(:users, "id:#{node['django']['users']}") do |u|
end
