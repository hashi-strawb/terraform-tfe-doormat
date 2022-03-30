#!/bin/bash

# If there is a running doormat process, wait for it to finish
# In this way, we naively prevent multiple doormat login browser sessions
#
# Also check for existing login.sh processes, excluding the current script's PID
while ps -ef | grep -v grep | grep -v $$ | grep -q "doormat login\|login.sh"
do
	echo "Waiting for previous doormat to finish"
	sleep 5
done

echo "Doormat login..."
doormat login -v || doormat login
