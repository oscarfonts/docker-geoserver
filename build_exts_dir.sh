#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEFAULT_EXTS_FILE="extensions"
DEFAULT_TARGET_DIR="geoserver-exts"

usage="Usage: $0 -v <gs_version> [-f <exts_file>] [-t <target_dir>] [-h]
  -f  extensions file. Default is '${DEFAULT_EXTS_FILE}' in the current directory.
  -v  GeoServer version.
  -t  target directory. Default is '${DEFAULT_TARGET_DIR}' in the current directory.
  -h  Show this help."

extsFile="${PWD}/${DEFAULT_EXTS_FILE}"
targetDir="${PWD}/${DEFAULT_TARGET_DIR}"

while getopts "hv:t:f:" option; do
  case $option in
    v)
      version=${OPTARG};;
    f)
      extsFile=${OPTARG};;
    t)
      targetDir=${OPTARG};;
    h)
      echo "$usage"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 2
      ;;
  esac
done

if [ -z "${version}" ]; then
  echo "Missing GeoServer version."
  echo "$usage"
  exit 3
fi

if [ -d "${targetDir}" ]; then
  echo "[WARN] Target directory already exists: $targetDir"
fi

if [ ! -f "${extsFile}" ]; then
  echo "Cannot find '${extsFile}' file."
  exit 1
fi

majorVersion=`echo ${version} | grep -Eo "[0-9]+\.[0-9]."`
baseSfUrl=http://sourceforge.net/projects/geoserver/files/GeoServer/${version}/extensions
baseAresUrl=http://ares.boundlessgeo.com/geoserver/${majorVersion}.x/community-latest/

exts=`sed 's/#.*$//g;/^$/d' ${extsFile} 2>/dev/null`

mkdir -p ${targetDir}
pushd ${targetDir} > /dev/null
echo "[INFO] Downloading extensions to ${targetDir}..."

for ext in ${exts}; do
  if [ ${ext} == "geofence" ]; then
    filename="geoserver-${majorVersion}-SNAPSHOT-geofence-plugin.zip"
    baseUrl=${baseAresUrl}
  elif [ ${ext} == "geofence-server" ]; then
    filename="geoserver-${majorVersion}-SNAPSHOT-geofence-server-plugin.zip"
    baseUrl=${baseAresUrl}
  else
    filename="geoserver-${version}-${ext}-plugin.zip"
    baseUrl=${baseSfUrl}
  fi

  echo "[INFO] * Extension: $ext..."
  wget "${baseUrl}/${filename}"

  if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download. Ignoring."
    continue
  fi

  unzip -d ${ext} ${filename}
  rm ${filename}
done

popd > /dev/null
echo "[INFO] Done."

