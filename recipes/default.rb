#
# Basic server config: basic users, packages, etc.
#
### Packages
# Just base packages required by the whole system here, please. Dependencies
# for other recipes should live int hose recipes.

node[:django][:base_packages].each do |pkg|
    package pkg do
        :upgrade
    end
end
Chef::Log.info("################### Django #####################")
node[:django][:apps].each do |app|
  Chef::Log.info("Dango Application: #{app}")
  search(:apps, "id:#{app} AND status:enable") do |a|
    search(:users, "id:#{a['user']}") do |u|
      username = u['username'] || u['id']
      Chef::Log.info(">>> Username: #{username} Home Dir: #{u['home']}")
      # TODO: в зависемости от переменных окружения production OR dev
      db = a[:databases][:production]

      application a[:id] do
    path "#{u['home']}/#{app}"
    owner username
    group username
    #owner node[:django][:users]
    #group node[:django][:users]
    #symlink_before_migrate "media"=>"media" 
    symlinks "media"=>"public/media", "db"=>"db", "system"=>"public/system", "log"=>"log"
    repository a[:repository]
    revision a[:revision]
    enable_submodules true
    #action :force_deploy
    force true
    migrate true if a[:migrate]
    #migration_command ""
    packages ["git-core", "mercurial", "python-pysqlite2", "python-virtualenv", "virtualenvwrapper", "python-mysqldb", "python-dev", "libmysqlclient-dev" ]
    deploy_key ::File.open("#{u[:home]}/.ssh/id_dsa", "r") { |file| file.read }

    django do
      packages ["redis", "mysql-python"]
      #deploy_to "/opt/djangotest/django-app/releases"
      requirements "#{u[:home]}/#{app}/shared/cached-copy/#{a[:requirements]}"
      #requirements "requirements/dev.txt"
      #local_settings_file "local.py"
      local_settings_file a[:local_settings_file] if a[:local_settings_file]
      base_django_app_path a[:base_django_app_path] if a[:base_django_app_path]
      #settings_template "settings.py.erb"
      settings_template a[:settings_template] if a[:settings_template]
      debug true if a[:debug]
      collectstatic "collectstatic -v 0 --clear --noinput"
      #manage_py_migration_commands ["compilemessages", "syncdb --noinput --migrate"]
      manage_py_migration_commands a[:manage_py_migration_commands]
      django_superusers a[:superusers] if a[:superusers]
      database do
        database db[:database]
        encoding db[:encoding]
        adapter db[:adapter]
        engine db[:engine]
        username db[:username]
        password db[:password]
        port db[:port]
        host db[:host] if db[:host]
      end
      database_master_role a[:database_master_role] if a[:database_master_role]
    end

    if a[:gunicorn]
      gunicorn do
        #only_if { node['roles'].include? 'packaginator_application_server' }
        app_module :django
        port a[:port].to_i
      end
    end 
  end

  #bag = node['user']['data_bag_name']
  #u = data_bag_item(bag, "username:#{node[:django][:users]}")
  #search(:users, "id:#{node['django']['users']}") do |u|
    end
  end
end
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
