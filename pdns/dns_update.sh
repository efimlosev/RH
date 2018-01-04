#!/bin/bash

for i in $(pdnsutil list-all-zones)
do
if [ ! -d "$i" ] # If thereis no such directory we will create it 
then
mkdir $i

fi
if [ ! -f "$i/$i.old" ]
then
pdnsutil list-zone $i > $i/$i.old # If there is no such file  we will create it

else
pdnsutil list-zone $i > $i/$i.new
DIFF=`diff $i/$i.old $i/$i.new` # if there is adiffrence we will update serial
echo $DIFF
if [ "$DIFF" != "" ]
then
pdnsutil increase-serial $i
pdnsutil list-zone $i > $i/$i.old 
pdns_control notify $i
rm $i/$i.new

fi
fi

done


