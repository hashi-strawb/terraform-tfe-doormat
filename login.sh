#!/bin/bash

# Sleep a random time to ensure we have only one instance of doormat running at a time
# A proper mutex would be better, but this works okay
sleep_timer=$(( ( RANDOM % 10 )  + 1 ))
sleep ${sleep_timer}
echo Sleeping ${sleep_timer}

# If there is a running doormat process, wait for it to finish
# In this way, we naively prevent multiple doormat login browser sessions
while ps -ef | grep -v grep | grep -q "doormat login"
do
	echo "Waiting for previous doormat to finish"
	sleep 5
done

echo "Doormat login..."
doormat login -v || doormat login
