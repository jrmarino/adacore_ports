#!/bin/sh
#
# This script copies all the ravensource ports back ot this
# directory for the purpose of a mass update.
#

origin="$1"

usage () {
  echo "$1"
  echo "usage: ./sync_from_raven.sh <path-to-ravensource-dir>"
  exit 1 
}

if [ -z "$origin" ]; then
   usage "Required <path-to-ravensource-dir> argument missing"
fi

if [ ! -d "$origin" ]; then
   usage "Argument 1 is not a directory: ${origin}"
fi

if [ ! -d "${origin}/bucket_00" ]; then
   usage "Argument 1 is not the ravensource directory: ${origin}"
fi

DPATH=$(dirname "$0")
ADACORE_DIR=$(cd "${DPATH}" && pwd -P)

(cd "$ADACORE_DIR" && find * -type d -name "bucket_*" ! -empty) | while read bucket
do
   (cd "${ADACORE_DIR}/${bucket}" && find * -type d -depth 0) | while read portdir
   do
      if [ -d "${origin}/${bucket}/${portdir}" ]
      then
         if rm -rf "${ADACORE_DIR}/${bucket}/${portdir}"
         then
            echo "transfer ${bucket}/${portdir}"
            cp -a "${origin}/${bucket}/${portdir}" "${ADACORE_DIR}/${destino}/${bucket}/"
         else
            echo "failed to delete ${bucket}/${portdir} port"
         fi      
      fi
   done
done
