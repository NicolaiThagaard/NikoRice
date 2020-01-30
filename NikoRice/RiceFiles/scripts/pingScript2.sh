#!/bin/bash

while true; do
  COMMAND=$(
timeout 0.1 ping -c 1 www.google.com &>/dev/zero
if [ $? -eq 0 ]; then
        printf "
  +----------------------------------------+
  |                                        |
  |                Target:                 |
  |                                        |
  |            +--------------+            |
  |            |www.google.com|            |
  |            +--------------+            |
  |                                        |
  |          Ping is successful!:          |
  |                                        |
  |   +--------------------------------+   |
  |   |Connection to GoogleDomain is UP|   |
  |   +--------------------------------+   |
  |                                        |
  +----------------------------------------+
"
else
        printf "
  +----------------------------------------+
  |                                        |
  |                Target:  	           |
  |			                   |
  |            +--------------+            |
  |            |www.google.com|            |
  |            +--------------+            |
  |					   |
  |            Ping has failed!:           |
  |			                   |
  |  +----------------------------------+  |
  |  |Connection to GoogleDomain is DOWN|  |
  |  +----------------------------------+  |
  |     				   |
  |   PS: Try resfreshing VPN-connection   |
  |                                        |
  +----------------------------------------+
"
fi
timeout 0.1 ping -c 1 -i 0.2 8.8.8.8 &>/dev/zero
if [ $? -eq 0 ]; then
	printf "
  +----------------------------------------+
  |                                        |
  |                Target:                 |
  |                                        |
  |            +-------------+             |
  |            |   8.8.8.8   |             |
  |            +-------------+             |
  |                                        |
  |          Ping is successful!:          |
  |                                        |
  |   +--------------------------------+   |
  |   |Connection to GoogleDomain is UP|   |
  |   +--------------------------------+   |
  |                                        |
  +----------------------------------------+
"
else
	printf "
  +----------------------------------------+
  |                                        |
  |                Target:                 |
  |                                        |
  |            +-------------+             |
  |            |   8.8.8.8   |             |
  |            +-------------+             |
  |                                        |
  |           Ping has failed!:            |
  |                                        |
  |  +----------------------------------+  |
  |  |Connection to GoogleDomain is DOWN|  |
  |  +----------------------------------+  |
  |                                        |
  +----------------------------------------+
"
fi

)						#Save command result in a var.
  echo "$COMMAND" 				#Print command result, including new lines.
  sleep 6 					#Keep above's output on screen during <x> seconds before clearing it
 						#Following code clears previously printed lines
  LINES=$(echo "$COMMAND" | wc -l) 		#Calculate number of lines for the output previously printed
  for (( i=1; i <= $(($LINES)); i++ ));do 	#For each line printed as a result of "<above ping commands>"
    tput cuu1 					#Move cursor up by one line
    tput el 					#Clear the line
  done
done

/bin/bash
