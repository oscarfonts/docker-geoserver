#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GEOSERVER_VERSION=`sed -n 's/ENV GEOSERVER_VERSION\s*//p' ${DIR}/Dockerfile`
BASE_SF_URL=http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions
BASE_ARES_URL=http://ares.boundlessgeo.com/geoserver/2.9.x/community-latest/
EXTS_FILE=$PWD/extensions

if [ ! -f "${EXTS_FILE}" ]; then
  echo "Cannot find '${EXTS_FILE}' file."
  exit 1
fi

if [ $# -eq 0 ]; then
  extsDir=geoserver-exts
elif [ $# -eq 1 ]; then
  extsDir=$1
else
  echo "Usage: $0 [target_dir]"
  exit 2
fi

mkdir -p ${extsDir}
pushd ${extsDir} > /dev/null
echo "[INFO] Downloading extensions to $extsDir..."

exts=`sed 's/#.*$//g;/^$/d' ${EXTS_FILE} 2>/dev/null`
for ext in ${exts}; do
  if [ ${ext} == "geofence" ]; then
    filename="geoserver-2.9-SNAPSHOT-geofence-plugin.zip"
    baseUrl=${BASE_ARES_URL}
  elif [ ${ext} == "geofence-server" ]; then
    filename="geoserver-2.9-SNAPSHOT-geofence-server-plugin.zip"
    baseUrl=${BASE_ARES_URL}
  else
    filename="geoserver-${GEOSERVER_VERSION}-${ext}-plugin.zip"
    baseUrl=${BASE_SF_URL}
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

