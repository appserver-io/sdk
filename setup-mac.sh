#!/bin/bash
#title			:setup-mac.sh
#description	:This script configures appserver components
#author 		:Marcus Döllerer
#date			:20170919
#usage			:bash setup-mac.sh

#####################
### Configuration ###
#####################

# Directory to which the selected repositories will be cloned
WORKSPACE_DIR="$HOME/workspace/appserver-sdk"

# Path to the sdk
# Please change if you run the script from a different directory
SCRIPT_DIR=`pwd`

# The build version of the runtime which will be installed
APPSERVER_RUNTIME_VERSION="1.1.9-118_x86_64"

# vendor/name:branch of the appserver repository
APPSERVER_REPOSITORY="appserver-io/appserver:1.1"

# Array of components to configure (vendor/name:branch)
# Just comment out or remove entries you don't need
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
	'appserver-io/lang:3.0'
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
	'appserver-io/robo-tasks'
	'appserver-io/provisioning'
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
	'appserver-io-psr/cli'
	'appserver-io-psr/application-server'
)

############################
###	Function Definitions ###
############################

function clone {
	componentBranch=$(getComponentBranch $1)
	component=$(removeBranchVersion $1)

	if ! git clone https://github.com/$component.git "$2/"
		then
		return
	fi

	if [[ ! "$componentBranch" = "" ]]
		then
		cd "$2"
		git checkout -b $componentBranch origin/$componentBranch
	fi
}

function linkComponent {

	removeComponent $1 $2

	component=$1
	pre1="appserver-io/"
	pre2="appserver-io-psr/"

	if [[ "$component" =~ ^"$pre1" ]]
		then
		cd "$WORKSPACE_DIR/appserver/vendor/appserver-io/"
		ln -s ../../../$2/
	else
		if [[ "$component" =~ ^"$pre2" ]]
			then
			cd "$WORKSPACE_DIR/appserver/vendor/appserver-io-psr/"
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

	if [[ -d "$WORKSPACE_DIR/appserver/vendor/$VENDOR/$2" ]]
		then
		rm -rf "$WORKSPACE_DIR/appserver/vendor/$VENDOR/$2"
	fi
}

function removeBranchVersion {
	componentBranch=$(getComponentBranch $1)
	suffix=":$componentBranch"
	result=${1%$suffix}
	echo "$result"
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

	result=$(removeBranchVersion $result)
	echo "$result"
}

function getComponentBranch {
	result=`cut -d ":" -f 2 <<< "$1"`
	if [[ "$result" = "$1" ]]
		then
		result=""
	fi
	echo "$result"
}

function installRuntime {
	cd "$WORKSPACE_DIR/appserver/var/tmp"
	curl -O http://builds.appserver.io/mac/appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	tar xfz appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	cp -R -f "$WORKSPACE_DIR/appserver/var/tmp/appserver/"* "$WORKSPACE_DIR/appserver"
	rm appserver-runtime_$APPSERVER_RUNTIME_VERSION.tar.gz
	rm -rf appserver/
	echo "$APPSERVER_RUNTIME_VERSION" > "$WORKSPACE_DIR/appserver/var/tmp/runtime_version.properties"
}


########################
### Initialize setup ###
########################

if [[ $1 == "--workspace-dir"* ]]
	then
	if [[ $1 = "--workspace-dir" ]] && [[ ! $2 = "" ]]
		then
		WORKSPACE_DIR=$2
	else
		pre="--workspace-dir="
		WORKSPACE_DIR=${1#$pre}
	fi
fi

WORKSPACE_DIR="${WORKSPACE_DIR/#\~/$HOME}"

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
echo "  '$WORKSPACE_DIR'"
echo ""
echo "Shall we begin? (Press ENTER to continue, any other key to abort)"
read -s -n 1 begin

if [ ! "${#begin}" -eq 0 ]
	then
	exit
fi

echo ""
echo "The following repositories will be cloned:"
echo "$APPSERVER_REPOSITORY"
for full in "${COMPONENTS[@]}"
do
	echo $full
done
echo ""
echo "Continue? (Press ENTER to continue, any other key to abort)"
read -s -n 1 continue1

if [ ! "${#continue1}" -eq 0 ]
	then
	echo "Aborting ..."
	exit
fi

clone $APPSERVER_REPOSITORY "$WORKSPACE_DIR/appserver"

cd "$WORKSPACE_DIR/appserver"
git checkout -b 1.1 origin/1.1

composer install

for full in "${COMPONENTS[@]}"
do
	cd "$WORKSPACE_DIR"
	componentFQDN=$(removeBranchVersion $full)
	componentShort=$(getComponentShort $full)
	clone $full "$WORKSPACE_DIR/$componentShort"
	linkComponent $componentFQDN $componentShort
done

installRuntime

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

sudo ln -s "$WORKSPACE_DIR/appserver/" /opt

cp -R "$SCRIPT_DIR/sbin/"* "$WORKSPACE_DIR/appserver/sbin/"
cp -R "$SCRIPT_DIR/bin/"* "$WORKSPACE_DIR/appserver/bin/"

USER=`whoami`
sed -i '' -e "s/<param name=\"user\" type=\"string\">_www/<param name=\"user\" type=\"string\">$USER/g" "$WORKSPACE_DIR/appserver/etc/appserver/appserver.xml"

echo ""
echo "Setup complete. The configured repositories are accessable under '$WORKSPACE_DIR'."
echo "You may now start the appserver with '/opt/appserver/sbin/appserverctl start'"
echo ""
