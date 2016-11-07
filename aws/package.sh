#!/bin/bash

usage="$(basename "$0") -s <snapshot_id> -g <volume_size> [-d] [-t volume_type] [-f context_xml_file] [-h] -v <geoserver_version>

where:
    -h  show this help text
    -s  snapshot id
    -g  volume size in GB
    -d  delete on termination. Default is false
    -t  volume type. Default is gp2
    -v  Geoserver version. Default is 2.10.0"

delete_on_termination="false"
volume_size=""
volume_type="gp2"
geoserver_version="2.10.0"

while getopts "h?g:dt:s:f:v:" opt; do
    case "$opt" in
    h|\?)
        echo -e "$usage"
        exit 0
        ;;
    s)  snapshot_id=$OPTARG;;
    g)  volume_size=$OPTARG;;
    t)  volume_type=$OPTARG;;
    f)  context_xml_file=$OPTARG;;
    d)  delete_on_termination="true";;
    v)  geoserver_version=$OPTARG;;
    esac
done

if [ -z "$snapshot_id" ]; then
  echo -e "$usage"
  exit 1
fi;
if [ -z "$volume_size" ]; then
  echo -e "$usage"
  exit 1
fi;

blockdevice="$snapshot_id:$volume_size:$delete_on_termination:$volume_type"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p build/.ebextensions
mkdir build/conf

if [ -n "$context_xml_file" ]; then
  cp $context_xml_file build/conf
else
  cp $DIR/../$geoserver_version/conf/geoserver.xml build/conf
fi

cp $DIR/Dockerrun.aws.json build
cp env.config build/.ebextensions
sed "s/__block_device__/${blockdevice}/" ebs.config > build/.ebextensions/ebs.config

cd $DIR/build
zip -r ../geoserver.zip * .ebextensions
cd - > /dev/null

# rm -rf build

