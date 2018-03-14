#!/bin/bash
#Created by wpcheng

source ./envsetup.sh

function assemble() {
    #$1是项目名称，$2是项目标号（01 02 ...）
    echo "assemble(): $1, $2"
    git checkout $1
    echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n <resources>\n<string name=\"version_name\">$2</string>\n<string name=\"version_code\">11</string>\n</resources>">"res/values/version.xml"
    cat "res/values/version.xml"
    ./gradlew assembleRelease
    echo -e "\n\n\n\n"
    echo "-------------------------------------------------copy mapping.txt！-------------------------------------------------"
    echo -e "\n\n\n\n"
    cp build/outputs/mapping/release/mapping.txt ./mapping.txt
    git commit -a -m "发布版本$2"
    git tag "$2"
    echo -e "\n\n\n\n"
    echo "-------------------------------------------------我是分割线！Oh Yeah！-------------------------------------------------"
    echo -e "\n\n\n\n"

}

function assembleAll() {
	count=0
	while [ $count -lt ${#all_projects[@]} ]
	do
		assemble ${all_projects[$count]} ecarx_${targetVersion}_${version_suffix[$count]} 
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

echo "Please input version number:"
read targetVersion

if [ ${#targetIndex[@]} == 1 ]
then
	if [ ${targetIndex[0]} = "all" ]
	then
		assembleAll 
	elif [ ${targetIndex[0]} -ge 0 ] && [ ${targetIndex[0]} -lt ${#all_projects[@]} ]
	then
		assemble ${all_projects[${targetIndex[0]}]} ecarx_${targetVersion}_${version_suffix[${targetIndex[0]}]} 
	else 
		echo "Target project cannot be found!"
	fi
elif [ ${#targetIndex[@]} -gt 1 ]
then
	for i in ${targetIndex[@]}
	do
		assemble ${all_projects[$i]} ecarx_${targetVersion}_${version_suffix[$i]} 
	done
else
	echo "invalid value"
fi


