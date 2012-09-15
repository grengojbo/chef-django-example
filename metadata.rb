maintainer       "Oleg Dolya"
maintainer_email "oleg.dolya@gmail.com"
license          "Apache 2.0"
description      "Deploys and configures Django applications"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.3"

%w{ application_python application python gunicorn supervisor }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end
