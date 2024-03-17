#!/bin/sh


date=$(date +"%Y%m%d")
if [ -f ${date}/se.zone ] ; then
	zone=$(cat ${date}/se.zone | wc -l)
else
	zone=$(zcat ${date}/se.zone.gz | wc -l)
fi
if [ -f $date/ns.txt ] ; then
	ns=$(grep " true" ${date}/ns.txt | wc -l)
else
	ns=$(zgrep " true" ${date}/ns.txt.gz | wc -l)
fi
if [ -f $date/mx.txt ] ; then
	mx=$(grep " true" ${date}/mx.txt | wc -l)
else
	mx=$(zgrep " true" ${date}/mx.txt.gz | wc -l)
fi
if [ -f $date/www.txt ] ; then
	www=$(grep " true" ${date}/www.txt | wc -l)
else
	www=$(zgrep " true" ${date}/www.txt.gz | wc -l)
fi

echo "At $date the .se zone contains $zone domains"
echo $(printf "%.2f\n" $(echo "${www} / ${zone} * 100"|bc -l) ) "% have IPv6 on www"
echo $(printf "%.2f\n" $(echo "${ns} / ${zone} * 100"|bc -l ) ) "% have IPv6 on one or more DNS"
echo $(printf "%.2f\n" $(echo "${mx} / ${zone} * 100"|bc -l ) ) "% have IPv6 on one or more MX"

echo
echo "Date		www	ns	mx"
dates=$(ls | grep 20 | sort -r | head)
for i in ${dates} ; do
	if [ -f ${i}/se.zone ] ; then
		zone=$(cat ${i}/se.zone | wc -l)
        else
		zone=$(zcat ${i}/se.zone.gz | wc -l)
        fi
	if [ -f ${i}/ns.txt ] ; then
		ns=$(grep " true" ${i}/ns.txt | wc -l)
	else
		ns=$(zgrep " true" ${i}/ns.txt.gz | wc -l)
	fi
	if [ -f ${i}/mx.txt ] ; then
                mx=$(grep " true" ${i}/mx.txt | wc -l)
        else
                mx=$(zgrep " true" ${i}/mx.txt.gz | wc -l)
        fi
	if [ -f ${i}/www.txt ] ; then
                www=$(grep " true" ${i}/www.txt | wc -l)
        else
                www=$(zgrep " true" ${i}/www.txt.gz | wc -l)
        fi

	wwwold=$(echo $(printf "%.2f\n" $(echo "$www / $zone * 100"|bc -l) ))
	nsold=$(echo $(printf "%.2f\n" $(echo "$ns / $zone * 100"|bc -l) ))
	mxold=$(echo $(printf "%.2f\n" $(echo "$mx / $zone * 100"|bc -l) ))
	echo	"$i	$wwwold	$nsold	$mxold"
done
gzip ${date}/*
