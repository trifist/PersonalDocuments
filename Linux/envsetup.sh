#!/bin/bash
#Created by wpcheng

export all_projects=(
black_SpeechSuitePack_1078
SpeechSuitePack_1078
lynkco_SpeechSuitePack_1078
kc2_SSP_1078
kc2_SSP_1097
fe6_SSP_1078
cv_SSP_1097
sx11_SSP_1078
)

export version_suffix=(
black
blue
lynkco
kc2_78
kc2_97
fe6_78
cv_97
sx11_78
)

function printAll() {
	for project in ${all_projects[@]}
	do
		echo $project
	done
}

getopts "l" opt

case $opt in
	l)
		printAll;;
	?)
esac
