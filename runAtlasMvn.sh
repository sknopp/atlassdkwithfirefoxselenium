#!/bin/bash

trap 'exit 0' INT SIGTERM

# launch pseudo display for selenium tests
Xvfb :99 &

echo "loading project files into docker container. This could take a second, please wait ..."
cp -r /app /tmp/ && cd /tmp/app


function copy_back_on_signal() {
	trap '' INT
	echo "Copying back target directory to host. This could take a second, please wait..."
	rm -rf /app/target

	# check if target folder still exists (maybe 'clean' has been run?)
	if [ -d /tmp/app/target ]
	then
	        cp -r /tmp/app/target/ /app
	fi
}

trap copy_back_on_signal SIGTERM INT

# run requested Atlassian Maven command
atlas-$@ -Dserver=127.0.0.1
