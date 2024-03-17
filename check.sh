#!/bin/sh


date=$(date +"%Y%m%d")
if [ ! -d ${date} ] ; then
	mkdir ${date}
fi	

echo Fetching se.zone
dig @zonedata.iis.se se AXFR | ggrep -v -E 'DNSKEY|RRSIG|DS|^.\.ns\.' | awk '{print $1}' | sort -u | ggrep -v ^ns|ggrep -v ^dns | ggrep -v ';' | sed '/^$/d' > $date/se.zone
echo Digging se.zone for information

go run ipv6ns.go $date/se.zone > $date/ns.txt &
go run ipv6.go $date/se.zone > $date/www.txt &
go run ipv6mx.go $date/se.zone > $date/mx.txt &


