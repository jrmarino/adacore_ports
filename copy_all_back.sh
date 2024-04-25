#!/bin/sh
#
# This script copies all the ports back to the given ravensource
# directory for the purpose of a mass update.
#

destino="$1"

usage () {
  echo "$1"
  echo "usage: ./copy_all_back.sh <path-to-ravensource-dir>"
  exit 1 
}

if [ -z "$destino" ]; then
   usage "Required <path-to-ravensource-dir> argument missing"
fi

if [ ! -d "$destino" ]; then
   usage "Argument 1 is not a directory: ${destino}"
fi

if [ ! -d "${destino}/bucket_00" ]; then
   usage "Argument 1 is not the ravensource directory: ${destino}"
fi

DPATH=$(dirname "$0")
ADACORE_DIR=$(cd "${DPATH}" && pwd -P)

(cd "$ADACORE_DIR" && find * -type d -name "bucket_*" ! -empty) | while read bucket
do
   (cd "${ADACORE_DIR}/${bucket}" && find * -type d -depth 0) | while read portdir
   do
      if rm -rf "${destino}/${bucket}/${portdir}"
      then
         echo "transfer ${bucket}/${portdir}"
         cp -a "${ADACORE_DIR}/${bucket}/${portdir}" "${destino}/${bucket}/"
      else
         echo "failed to delete ${bucket}/${portdir} port"
      fi
   done
done
