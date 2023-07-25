#!/bin/bash
#author: David Bartenstein
#you can use this script to paste in a copied text and it will grep all ip's inside the text and output their hostnames and country codes.
yellow=$(tput setaf 3)
bold=$(tput bold)
normal=$(tput sgr0)

echo From which text do you wish to see the ip\'s and hostnames? \(paste text -\> press enter -\> press ctrl D\):
readarray -t input # IFS=$'\n'  and the -t strips the newlines from the input - eventueel nog IFS=': '  - hoe maak ik dit silent?

declare -a greppedIPs
for i in ${!input[@]};
do
readarray -t grepped <<< "$( grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|([0-9a-f]{1,4}:+){3,7}[0-9a-f]{1,4}' <<< "${input[i]}" )"
greppedIPs+=( $grepped )
done

echo "################# * #################";
for x in ${!greppedIPs[@]};
do
echo -n "${bold}${yellow}${greppedIPs[x]}" '-->'
if [[ -n "$( grep "${greppedIPs[x]}" /etc/hosts )" && "$( host "${greppedIPs[x]}")" != *"not found"* ]];
   then
      echo "${normal}$( grep  "${greppedIPs[x]} " /etc/hosts )"
   else
      echo "${normal}$( host "${greppedIPs[x]}" )"
fi
echo "${bold}$( whois "${greppedIPs[x]}" | grep country )"
done
