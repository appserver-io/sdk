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

# The build version of the runtime which will be installed
APPSERVER_RUNTIME_VERSION="1.1.7-109_x86_64"

# vendor/name:branch of the appserver repository
APPSERVER_REPOSITORY="appserver-io/appserver:1.1"

# Array of components to configure (vendor/name:branch)
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
When you are done configuring the script to fit your needs, just start it up. No parameters required.

```bash
$ cd /path/to/sdk
$ ./setup-mac.sh
```

To overwrite the workspace directory via commandline, simply type

```bash
$ ./setup-mac.sh --workspace-dir="/Path/To/Workspace/"
```