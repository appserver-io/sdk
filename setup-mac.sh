git clone git@github.com:appserver-io/appserver.git ~/Workspace/appserver-io/appserver
git clone git@github.com:appserver-io/appserver.git ~/Workspace/appserver-io/authenticator
git clone git@github.com:appserver-io/build.git ~/Workspace/appserver-io/build
git clone git@github.com:appserver-io/collections.git ~/Workspace/appserver-io/collections
git clone git@github.com:appserver-io/concurrency.git ~/Workspace/appserver-io/concurrency
git clone git@github.com:appserver-io/configuration.git ~/Workspace/appserver-io/configuration
git clone git@github.com:appserver-io/description.git ~/Workspace/appserver-io/description
git clone git@github.com:appserver-io/dnsserver.git ~/Workspace/appserver-io/dnsserver
git clone git@github.com:appserver-io/doppelgaenger.git ~/Workspace/appserver-io/doppelgaenger
git clone git@github.com:appserver-io/fastcgi.git ~/Workspace/appserver-io/fastcgi
git clone git@github.com:appserver-io/http.git ~/Workspace/appserver-io/http
git clone git@github.com:appserver-io/lang.git ~/Workspace/appserver-io/lang
git clone git@github.com:appserver-io/logger.git ~/Workspace/appserver-io/logger
git clone git@github.com:appserver-io/messaging.git ~/Workspace/appserver-io/messaging
git clone git@github.com:appserver-io/microcron.git ~/Workspace/appserver-io/microcron
git clone git@github.com:appserver-io/properties.git ~/Workspace/appserver-io/properties
git clone git@github.com:appserver-io/pthreads-polyfill.git ~/Workspace/appserver-io/pthreads-polyfill
git clone git@github.com:appserver-io/rmi.git ~/Workspace/appserver-io/rmi
git clone git@github.com:appserver-io/robo-tasks.git ~/Workspace/appserver-io/robo-tasks
git clone git@github.com:appserver-io/routlt.git ~/Workspace/appserver-io/routlt
git clone git@github.com:appserver-io/routlt-project.git ~/Workspace/appserver-io/routlt-project
git clone git@github.com:appserver-io/server.git ~/Workspace/appserver-io/server
git clone git@github.com:appserver-io/single-app.git ~/Workspace/appserver-io/single-app
git clone git@github.com:appserver-io/storage.git ~/Workspace/appserver-io/storage
git clone git@github.com:appserver-io/webserver.git ~/Workspace/appserver-io/webserver
git clone git@github.com:appserver-io-psr/application.git ~/Workspace/appserver-io/application
git clone git@github.com:appserver-io-psr/auth.git ~/Workspace/appserver-io/auth
git clone git@github.com:appserver-io-psr/context.git ~/Workspace/appserver-io/context
git clone git@github.com:appserver-io-psr/deployment.git ~/Workspace/appserver-io/deployment
git clone git@github.com:appserver-io-psr/di.git ~/Workspace/appserver-io/di
git clone git@github.com:appserver-io-psr/epb.git ~/Workspace/appserver-io/epb
git clone git@github.com:appserver-io-psr/http-message.git ~/Workspace/appserver-io/http-message
git clone git@github.com:appserver-io-psr/mop.git ~/Workspace/appserver-io/mop
git clone git@github.com:appserver-io-psr/naming.git ~/Workspace/appserver-io/naming
git clone git@github.com:appserver-io-psr/pms.git ~/Workspace/appserver-io/pms
git clone git@github.com:appserver-io-psr/security.git ~/Workspace/appserver-io/security
git clone git@github.com:appserver-io-psr/servlet.git ~/Workspace/appserver-io/servlet
git clone git@github.com:appserver-io-psr/socket.git ~/Workspace/appserver-io/socket

cd ~/Workspace/appserver-io/appserver/var/tmp
curl -O http://builds.appserver.io/mac/appserver-runtime_1.1.7-109_x86_64.tar.gz
tar xvfz appserver-runtime_1.1.7-109_x86_64.tar.gz
cp -R -f ~/Workspace/appserver-io/appserver/var/tmp/appserver/* ~/Workspace/appserver-io/appserver

ln -s ~/Workspace/appserver-io/appserver /opt/appserver
cd /opt/appserver
composer install --ignore-platform-reqs

rm -rf ~/Workspace/appserver-io/appserver/vendor/appserver-io/*
cd ~/Workspace/appserver-io/appserver/vendor/appserver-io
ln -s ../../../authenticator
ln -s ../../../build
ln -s ../../../collections
ln -s ../../../concurrency
ln -s ../../../configuration
ln -s ../../../description
ln -s ../../../dnsserver
ln -s ../../../doppelgaenger
ln -s ../../../fastcgi
ln -s ../../../http
ln -s ../../../lang
ln -s ../../../logger
ln -s ../../../messaging
ln -s ../../../microcron
ln -s ../../../properties
ln -s ../../../pthreads
ln -s ../../../rmi
ln -s ../../../robo-tasks
ln -s ../../../routlt
ln -s ../../../routlt
ln -s ../../../server
ln -s ../../../single-app
ln -s ../../../storage
ln -s ../../../webserver

rm -rf ~/Workspace/appserver-io/appserver/vendor/appserver-io-psr/*
cd ~/Workspace/appserver-io/appserver/vendor/appserver-io-psr
ln -s ../../../application
ln -s ../../../auth
ln -s ../../../context
ln -s ../../../deployment
ln -s ../../../di
ln -s ../../../epb
ln -s ../../../http-message
ln -s ../../../mop
ln -s ../../../naming
ln -s ../../../pms
ln -s ../../../security
ln -s ../../../servlet
ln -s ../../../socket

# Symlink sbin/appserver/appserverctl