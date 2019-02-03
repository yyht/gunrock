#!/bin/bash

# get all execution files in ./bin
files=(./bin/*)
# split file names into arr
arr=$(echo $files | tr " " "\n")
max_ver_num="$"

exe_file=${arr[0]}
# iterate over all file names to get the largest version number
for x in $arr
do
    output=$(grep -o "[0-9]\.[0-9]" <<<"$x")
    if [ "$output" \> "$max_ver_num" ]; then
        exe_file=$x
    fi
done

EXECUTION=$exe_file

# addresses
DATADIR="/data/gunrock_dataset/large"

# graphs
NAME[0]="soc-LiveJournal1" 	&& K[0]="10" && EPS[0]="5" && MINPTS[0]="7"
NAME[1]="soc-orkut" 		&& K[1]="10" && EPS[1]="5" && MINPTS[1]="7"
NAME[2]="hollywood-2009" 	&& K[2]="10" && EPS[2]="5" && MINPTS[2]="7"
NAME[3]="indochina-2004" 	&& K[3]="10" && EPS[3]="5" && MINPTS[3]="7"
NAME[4]="rgg_n_2_19_s0" 	&& K[4]="10" && EPS[4]="5" && MINPTS[4]="7"
NAME[5]="rgg_n_2_20_s0" 	&& K[5]="10" && EPS[5]="5" && MINPTS[5]="7"
NAME[6]="rgg_n_2_21_s0" 	&& K[6]="10" && EPS[6]="5" && MINPTS[6]="7"
NAME[7]="rgg_n_2_22_s0" 	&& K[7]="10" && EPS[7]="5" && MINPTS[7]="7"
NAME[8]="road_usa" 		&& K[8]="10" && EPS[8]="5" && MINPTS[8]="7"

# network graphs

GRAPH[0]="market $DATADIR/${NAME[0]}/${NAME[0]}.mtx"
GRAPH[1]="market $DATADIR/${NAME[1]}/${NAME[1]}.mtx"
GRAPH[2]="market $DATADIR/${NAME[2]}/${NAME[2]}.mtx"
GRAPH[3]="market $DATADIR/${NAME[3]}/${NAME[3]}.mtx"
GRAPH[4]="market $DATADIR/${NAME[4]}/${NAME[4]}.mtx"
GRAPH[5]="market $DATADIR/${NAME[5]}/${NAME[5]}.mtx"
GRAPH[6]="market $DATADIR/${NAME[6]}/${NAME[6]}.mtx"
GRAPH[7]="market $DATADIR/${NAME[7]}/${NAME[7]}.mtx"
GRAPH[8]="market $DATADIR/${NAME[8]}/${NAME[8]}.mtx"

# parameters
OPTIONS="--quick --snn=true --tag=Gunrock/SNN_GRAPL19"

for i in {0..8}
do
    SUFFIX="V100_Ubuntu_18-04"
    mkdir -p eval/$SUFFIX
    DEVICE="2"

    echo $EXECUTION ${GRAPH[$i]} --k=${K[$i]} --eps=${EPS[$i]} --min-pts=${MINPTS[$i]} $OPTIONS --device=$DEVICE --jsondir=./eval/$SUFFIX "> ./eval/$SUFFIX/${NAME[$i]}.txt"
    $EXECUTION ${GRAPH[$i]} --k=${K[$i]} --eps=${EPS[$i]} --min-pts=${MINPTS[$i]} $OPTIONS --device=$DEVICE --jsondir=./eval/$SUFFIX  > ./eval/$SUFFIX/${NAME[$i]}.txt
    sleep 1
done
