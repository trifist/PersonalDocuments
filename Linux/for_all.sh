#!/bin/bash
#Created by wpcheng

source ./envsetup.sh

function execute() {
    #$1是项目名称，$2是项目标号（01 02 ...）
    echo "execute(): $2" 
    git checkout $1
    $2
}

function executeAll() {
	count=0
	while [ $count -lt ${#all_projects[@]} ]
	do
		execute ${all_projects[$count]} "$1"
		let count++
	done
}

index=0
printf "%-10s %-10s\n" index project
while [ $index -lt ${#all_projects[@]} ]
do
	printf "%-10s %-10s\n" $index ${all_projects[$index]}
	let index++
done

echo "Please choose the project you want to compile:"
read -a targetIndex 

if [ ${#targetIndex[@]} == 1 ]
then
	if [ ${targetIndex[0]} = "all" ]
	then
		executeAll "$1" 
	elif [ ${targetIndex[0]} -ge 0 ] && [ ${targetIndex[0]} -lt ${#all_projects[@]} ]
	then
		execute ${all_projects[${targetIndex[0]}]} "$1"
	else 
		echo "Target project cannot be found!"
	fi
elif [ ${#targetIndex[@]} -gt 1 ]
then
	for i in ${targetIndex[@]}
	do
		execute ${all_projects[$i]} "$1"
	done
else
	echo "invalid value"
fi


