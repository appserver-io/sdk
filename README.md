# Appserver SDK
This simple bash script enables interested developers to work on the sources of appserver and its components locally without creating complex docker mounts or builds with Ant.

### Supported Platforms
At the moment, this script only supports OS X. 
Support for a variety of Linux distributions will follow soon.

### Installation
Simply clone this repository to your desired destination and you're done

```bash
$ git clone https://github.com/appserver-io/sdk.git
$ cd sdk/
```

### Configuration
The script contains a configuration segment which allows modification of the following variables:

```bash
# Directory to which the selected repositories will be cloned
WORKSPACE_DIR="$HOME/workspace/appserver-sdk"

# Path to the sdk
# Please change if you run the script from a different directory
SCRIPT_DIR=`pwd`

# Array of components you want to work on
# Just comment out or remove entries you don't need
COMPONENTS=(
    'appserver-io/authenticator'
    'appserver-io/build'
    ...
)

# The build version of the runtime which will be installed
APPSERVER_RUNTIME_VERSION="1.1.7-109_x86_64"
```

### Usage
Once you configured the script to fit your needs, just start it up. No parameters required.

```bash
$ cd /path/to/sdk
$ ./setup-mac.sh
```
You will be asked to enter your Github Username and whether or not you want to fork the selected repositories to your Github account automatically.

> Please note that you need to fork every repository you are working on to your Github account in oder to be able to create Pull Requests. If you chose to neither use the built in functionality nor fork them manually, this setup script might not behave as expected as it relies on you having the repositories forked to your account.

If you are experiencing any issues with the built in 'auto-fork' functionality concerning authentication with your Github account, you may try to start the script using the parameter 'force-login'

```bash
$ ./setup-mac.sh force-login
```

This will remove the OAuth secret stored in ~/.config/hub and force you to enter your Github credentials again.
Find out more about Github OAuth tokens: [![Personal API Tokens](https://github.com/blog/1509-personal-api-tokens)](https://github.com/blog/1509-personal-api-tokens)
