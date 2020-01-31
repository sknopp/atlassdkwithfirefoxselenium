#!/bin/bash

TARGET_FOLDER=$ATLAS_TARGET_DIR

trap 'exit 0' INT SIGTERM

# launch pseudo display for selenium tests
Xvfb :99 &

if [ -d /app/target ]
then
	echo "loading existing project target files into docker container. This could take a second, please wait ..."
	cp -r /app/target /tmp/
fi

function copy_back_on_signal() {
	trap '' INT
	echo "Copying back target directory to host. This could take a second, please wait..."
	rm -rf $TARGET_FOLDER

	# check if target folder still exists (maybe 'clean' has been run?)
	if [ -d "$TARGET_FOLDER" ]
	then
		echo "found target folder!"
	        cp -r $TARGET_FOLDER /app
	fi
}

trap copy_back_on_signal SIGTERM INT

# run requested Atlassian Maven command
atlas-$@ -Dserver=127.0.0.1 -DbuildDirectory=$TARGET_FOLDER
