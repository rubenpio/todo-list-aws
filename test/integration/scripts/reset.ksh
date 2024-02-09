#!/bin/ksh
FILE=test/integration/todoApiTest.py
#URL
URL="$(egrep Value url.txt|tr -s " "|cut -f2 -d" "|grep todos|egrep -v id|uniq|sed 's/\/$//g'|uniq|sed 's/\/todos//g')"
# SED FILE
sed -i "s|\"${URL}\"|BASE_URI|g" $FILE
