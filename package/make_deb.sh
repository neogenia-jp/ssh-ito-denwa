#!/bin/bash

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

$INSTALL -d ${TARGET_DIR}/usr/lib/systemd/user/ssh-ito-denwa || exit 2
$CP -pr ${SRC_DIR} --target-directory ${TARGET_DIR}/usr/lib/systemd/user/ssh-ito-denwa/

$INSTALL ${SCRIPT_DIR}/init-script/service-def  ${TARGET_DIR}/usr/lib/systemd/user/ssh-ito-denwa/

dpkg -b ${TARGET_DIR} ${PKG_NAME}_${VERSION}.deb  || exit 3

