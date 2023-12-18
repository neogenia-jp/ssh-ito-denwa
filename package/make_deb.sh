#!/bin/bash
set -eo pipefail

SCRIPT_DIR=`dirname $0`
SRC_DIR=$SCRIPT_DIR/../src

PKG_NAME=ssh-ito-denwa
VERSION=0.0.1

INSTALL="install -D -v -p -o root -g root"
CP="cp --preserve=mode,timestamps"

if [ `whoami` != 'root' ]; then
  echo "You are not root. Prease retry as the super user."
  exit 1
fi

echo "building deb..."
TARGET_DIR=deb

rm -rf ${TARGET_DIR}/usr/  || exit 1

$INSTALL -d ${TARGET_DIR}/usr/local/lib/ssh-ito-denwa || exit 2
$CP -pr ${SRC_DIR} --target-directory ${TARGET_DIR}/usr/local/lib/ssh-ito-denwa/

$INSTALL -d ${TARGET_DIR}/usr/lib/systemd/system || exit 2
$INSTALL ${SCRIPT_DIR}/init-script/ssh-ito-denwa.service  ${TARGET_DIR}/usr/lib/systemd/system/

dpkg -b ${TARGET_DIR} ${PKG_NAME}_${VERSION}.deb  || exit 3


echo -- finished successfully --
echo "  to install: dpkg -i ${PKG_NAME}_${VERSION}.deb"
echo "  to uninstall: dpkg -r ${PKG_NAME}"
