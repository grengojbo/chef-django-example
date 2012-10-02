maintainer       "Oleg Dolya"
maintainer_email "oleg.dolya@gmail.com"
license          "Apache 2.0"
description      "Deploys and configures Django applications"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.4"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends "user"
depends "application"
depends "application_python"
