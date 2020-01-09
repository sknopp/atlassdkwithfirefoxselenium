#!/bin/bash

# launch pseudo display for selenium tests
Xvfb :99 &

# run requested Atlassian Maven command
atlas-mvn $@ -Dserver=127.0.0.1 -DbuildDirectory=/tmp/target/; cp -r /tmp/target/ /app
