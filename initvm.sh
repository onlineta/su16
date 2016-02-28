#!/usr/bin/env sh

set -e
set -x

VERNAME=su16vm-v1.0

curl -z "${VERNAME}.ova" -o "${VERNAME}.ova" \
  "http://napoleon.hiperfit.dk/~oleks/${VERNAME}.ova"

vboxmanage unregistervm "${VERNAME}" --delete || true

vboxmanage import "${VERNAME}.ova"

function sfmount () {
  vboxmanage sharedfolder add "${VERNAME}" \
    --name "$1" --hostpath "$PWD/$1" --automount
}

sfmount "conf"
sfmount "go"
sfmount "static"

mkdir -p log/nginx
sfmount "log"

vboxmanage startvm "${VERNAME}" --type headless
