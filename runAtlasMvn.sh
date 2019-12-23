#!/bin/bash

# launch pseudo display for selenium tests
Xvfb :99 &

# if target directory does not exist copy maven cache to target for speedup
if [ ! -d "target/" ]
then
	mkdir -p target
	cp -r /testlibs target/
elif [ ! -d "target/testlibs/" ]
then
	cp -r /testlibs target/
fi

# run requested Atlassian Maven command
atlas-mvn $@ -Dserver=127.0.0.1
