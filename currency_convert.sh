#!/bin/bash

# What was used here
## Argument passing
## Control structures(if, else, ...)
## sed (Stream Editor developed in 1970s)
## Regular expressions

FROM_CURRENCY="$1"
TO_CURRENCY="$2"
AMOUNT="$3"
LIMIT="2.0"

if [[ "$#" -ne 3 ]]; then
	echo "Please specify required parameters."
	echo "Example Usage: ./currency_convert.sh USD TRY 4."
	echo "Above example will give you the result of 4 USD in TRY."
else
	# Actual response: {"to": "EUR", "rate": 0.72770000000000001, "from": "USD", "v": 291.07999999999998}
	# Trimmed response: "to": "EUR", "rate": 0.72770000000000001, "from": "USD", "v": 291.07999999999998, "v": 23423423423423
	CURRENCY_RESPONSE=$(curl -s "http://rate-exchange.appspot.com/currency?from=$FROM_CURRENCY&to=$TO_CURRENCY&q=$AMOUNT" | sed -e 's/[{}]/''/g') 
	[[ $CURRENCY_RESPONSE =~ v\":(.*) ]] && echo "Result is: ${BASH_REMATCH[1]}"

	if [[ "$(echo ${BASH_REMATCH[1]}'>' $LIMIT | bc -l)" -eq 1 ]]; then
		subject="$FROM_CURRENCY is greater than $LIMIT : ${BASH_REMATCH[1]}"		
		recipients="alifuatates36@gmail.com"
		from="root@sunucu.net"
		mail="subject:$subject\nfrom:$from\n$subject"
		echo -e $mail | /usr/sbin/sendmail "$recipients"
	fi
fi
