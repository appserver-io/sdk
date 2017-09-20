#!/bin/bash
#title			:setup-mac.sh
#description	:This script configures appserver components
#author 		:doellererm
#date			:20170919
#usage			:bash setup-mac.sh [force-login]

#####################
### Configuration ###
#####################

WORKSPACE_DIR="$HOME/workspace/appserver-sdk"
APPSERVER_RUNTIME_VERSION="1.1.7-109_x86_64"
SCRIPT_DIR=`pwd`

# Components to configure
COMPONENTS=(
	'appserver-io/authenticator'
	'appserver-io/build'
	'appserver-io/collections'
	'appserver-io/concurrency'
	'appserver-io/configuration'
	'appserver-io/description'
	'appserver-io/dnsserver'
	'appserver-io/doppelgaenger'
	'appserver-io/fastcgi'
	'appserver-io/http'
	'appserver-io/lang'
	'appserver-io/logger'
	'appserver-io/messaging'
	'appserver-io/microcron'
	'appserver-io/properties'
	'appserver-io/pthreads-polyfill'
	'appserver-io/rmi'
	'appserver-io/robo-tasks'
	'appserver-io/routlt'
	'appserver-io/routlt-project'
	'appserver-io/server'
	'appserver-io/single-app'
	'appserver-io/storage'
	'appserver-io/webserver'
	'appserver-io-psr/application'
	'appserver-io-psr/auth'
	'appserver-io-psr/context'
	'appserver-io-psr/deployment'
	'appserver-io-psr/di'
	'appserver-io-psr/epb'
	'appserver-io-psr/http-message'
	'appserver-io-psr/mop'
	'appserver-io-psr/naming'
	'appserver-io-psr/pms'
	'appserver-io-psr/security'
	'appserver-io-psr/servlet'
	'appserver-io-psr/socket'
)

############################
###	Function Definitions ###
############################

function clone {
	if [[ -d $2 ]]
		then
		rm -rf $2
	fi
	git clone https://github.com/$1.git $2/
}

function fork {
	cd $1
	hub fork
	git remote rm origin
}

function linkComponent {

	removeComponent $1 $2

	component=$1
	pre1="appserver-io/"
	pre2="appserver-io-psr/"

	if [[ "$component" =~ ^"$pre1" ]]
		then
		cd $WORKSPACE_DIR/$GITHUB_USER/appserver/vendor/appserver-io/
		ln -s ../../../$2/
	else
		if [[ "$component" =~ ^"$pre2" ]]
			then
			cd $WORKSPACE_DIR/$GITHUB_USER/appserver/vendor/appserver-io-psr/
			ln -s ../../../$2/
		fi
	fi
}

function removeComponent {

	component=$1
	pre1="appserver-io/"
	pre2="appserver-io-psr/"

	if [[ "$component" =~ ^"$pre1" ]]
		then
		VENDOR="appserver-io"
	else
		if [[ "$component" =~ ^"$pre2" ]]
			then
			VENDOR="appserver-io-psr"
		fi
	fi

	if [[ -d $WORKSPACE_DIR/$GITHUB_USER/appserver/vendor/$VENDOR/$2 ]]
		then
		rm -rf $WORKSPACE_DIR/$GITHUB_USER/appserver/vendor/$VENDOR/$2
	fi
}

function getComponentShort {

	component=$1
	pre1="appserver-io/"
	pre2="appserver-io-psr/"

	if [[ "$component" =~ ^"$pre1" ]]
		then
		result=${component#$pre1}
	else
		if [[ "$component" =~ ^"$pre2" ]]
			then
			result=${component#$pre2}
		fi
	fi

	echo "$result"
}

function installDependencies {
	BREW_PATH=`which brew`
	HUB_PATH=`which hub`
	DEPENDENCIES=()

	if [ -z "$BREW_PATH" ]
		then
		DEPENDENCIES+=('brew')
	fi

	if [ -z "$HUB_PATH" ]
		then
		DEPENDENCIES+=('hub')
	fi

	if [ ! ${#DEPENDENCIES[@]} -eq 0 ]
		then
		echo "The following dependencies have to be installed in order to be able to fork:"
		echo ""

		for dependency in "${DEPENDENCIES[@]}"
		do
			echo $dependency
		done

		echo ""
		echo "Continue? (Press ENTER to continue, any other key to abort)"
		read -s -n 1 continue3

		if [ "${#continue3}" -eq 0 ]
			then
			if [ -z "$BREW_PATH" ]
				then
				/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
			fi

			if [ -z "$HUB_PATH" ]
				then
				brew install hub
			fi
		fi
	fi
	
}

function installRuntime {
	cd $WORKSPACE_DIR/$GITHUB_USER/appserver/var/tmp
	curl -O http://builds.appserver.io/mac/appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	tar xvfz appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	cp -R -f $WORKSPACE_DIR/$GITHUB_USER/appserver/var/tmp/appserver/* $WORKSPACE_DIR/$GITHUB_USER/appserver
	rm appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	rm -rf appserver/
	echo "$APPSERVER_RUNTIME_VERSION" > $WORKSPACE_DIR/$GITHUB_USER/appserver/var/tmp/runtime_version.properties
}


########################
### Initialize setup ###
########################

echo ""
echo '   ____ _____  ____  ________  ______   _____  _____(_)___  '
echo '  / __ `/ __ \/ __ \/ ___/ _ \/ ___/ | / / _ \/ ___/ / __ \ '
echo ' / /_/ / /_/ / /_/ (__  )  __/ /   | |/ /  __/ /  / / /_/ / '
echo ' \__,_/ .___/ .___/____/\___/_/    |___/\___/_(_)/_/\____/  '
echo '     /_/   /_/ '
echo ""

echo ""
echo "This script will set up appserver-io/appserver and selected"
echo "components as git repositories in the defined workspace."
echo ""
echo "Don't forget to have a look at the configuration segment of this script"
echo "and verify that WORKSPACE_DIR and COMPONENTS are set correctly"
echo ""
echo "Please make sure that you don't have any unsaved changes in"
echo ""
echo "  $WORKSPACE_DIR"
echo ""
echo "Shall we begin? (Press ENTER to continue, any other key to abort)"
read -s -n 1 begin

if [ ! "${#begin}" -eq 0 ]
	then
	exit
fi

echo ""
echo "Please enter your Github username: "
read GITHUB_USER

if [ -z "$GITHUB_USER" ]
	then
	echo "Github username must not be empty"
	exit
fi

if [[ -f "$HOME/.config/hub" ]] && [[ "$1" = "force-login" ]]
	then
	rm $HOME/.config/hub
fi

echo ""
echo "The following repositories will be cloned:"
for componentFQDN in "${COMPONENTS[@]}"
do
	echo $componentFQDN
done
echo ""
echo "Continue? (Press ENTER to continue, any other key to abort)"
read -s -n 1 continue1

if [ ! "${#continue1}" -eq 0 ]
	then
	echo "Aborting ..."
	exit
fi

echo ""
echo "Working on appserver sources requires you to fork its repositories to your github account."
echo "Do you want to fork these sources now? (Press ENTER to continue, any other key to skip)"
read -s -n 1 forkNow

mkdir -p $WORKSPACE_DIR/$GITHUB_USER && cd $WORKSPACE_DIR/$GITHUB_USER

if [ "${#forkNow}" -eq 0 ]
	then
	installDependencies
	clone appserver-io/appserver $WORKSPACE_DIR/$GITHUB_USER/appserver
	fork $WORKSPACE_DIR/$GITHUB_USER/appserver
else
	clone $GITHUB_USER/appserver $WORKSPACE_DIR/$GITHUB_USER/appserver
fi

cd $WORKSPACE_DIR/$GITHUB_USER/appserver
composer install --ignore-platform-reqs

for componentFQDN in "${COMPONENTS[@]}"
do
	cd $WORKSPACE_DIR
	componentShort=$(getComponentShort $componentFQDN)
	if [ "${#forkNow}" -eq 0 ]
		then
		clone $componentFQDN $WORKSPACE_DIR/$GITHUB_USER/$componentShort
		fork $WORKSPACE_DIR/$GITHUB_USER/$componentShort/
	else
		clone $GITHUB_USER/$componentShort $WORKSPACE_DIR/$GITHUB_USER/$componentShort
	fi
	linkComponent $componentFQDN $componentShort
done

if [[ ! -f $WORKSPACE_DIR/$GITHUB_USER/appserver/var/tmp/runtime_version.properties ]]
	then
	installRuntime
else
	RT=`cat $WORKSPACE_DIR/$GITHUB_USER/appserver/var/tmp/runtime_version.properties`
	if [[ "$RT" = "$APPSERVER_RUNTIME_VERSION" ]]
		then
		echo "[INFO] Runtime already up to date, skipping setup"
	else
		installRuntime
	fi
fi

echo "Creating symlink to /opt/appserver"
if [[ -L /opt/appserver ]]
	then
	sudo rm /opt/appserver
else
	if [[ -d /opt/appserver ]]
		then
		echo "[ERROR] Directory '/opt/appserver/' already exists but has to be removed in order to continue"
		echo "Please make sure you do not have any important files in '/opt/appserver/'"
		echo ""
		echo "Continue? (Press ENTER to continue, any other key to abort)"
		read -s -n 1 continue2

		if [ ! "${#continue1}" -eq 0 ]
			then
			echo "Aborting ..."
			exit
		fi
		sudo rm -rf /opt/appserver
	fi
fi

sudo ln -s $WORKSPACE_DIR/$GITHUB_USER/appserver/ /opt

cp -R $SCRIPT_DIR/sbin/* $WORKSPACE_DIR/$GITHUB_USER/appserver/sbin/
cp -R $SCRIPT_DIR/bin/* $WORKSPACE_DIR/$GITHUB_USER/appserver/bin/

USER=`whoami`
sed -i -e "s/<param name=\"user\" type=\"string\">_www/<param name=\"user\" type=\"string\">$USER/g" $WORKSPACE_DIR/$GITHUB_USER/appserver/etc/appserver/appserver.xml

echo ""
echo "Setup complete. The configured repositories are accessable under '$WORKSPACE_DIR/$GITHUB_USER'."
echo "You may now start the appserver with '/opt/appserver/sbin/appserverctl start'"
echo ""
