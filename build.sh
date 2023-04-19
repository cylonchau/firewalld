#!/bin/bash
set -ex

WORK_DIR=$(pwd)
RPM_DIR=~/rpmbuild

function installRequirementsPackage() {
  yum install -y \
    desktop-file-utils \
    gettext \
    intltool \
    glib2 \
    glib2-devel \
    systemd-units \
    iptables \
    ebtables \
    ipset \
    nftables \
    dbus-python \
    python-slip-dbus \
    python-decorator \
    pygobject3-base \
    docbook-style-xsl
}

function initWorkDir() {
  [ -d ${RPM_DIR}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} ] || mkdir -pv ${RPM_DIR}/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
}

function generatePackage(){
  packageName=$(basename `pwd`)
  parentDir=$(dirname ${WORK_DIR})
  cd ${WORK_DIR}
  chmod +x autogen.sh
  \cp -a config/FirewallD.conf config/firewalld.conf
  \cp -a firewalld.spec ${RPM_DIR}/SPECS/firewalld.spec
  \cp -a ${parentDir}/${packageName} /tmp/${packageName}-0.6.3
  tar zcf /tmp/${packageName}.tar.gz -C /tmp/ ${packageName}-0.6.3
  \mv -f /tmp/${packageName}.tar.gz ${RPM_DIR}/SOURCES/${packageName}.tar.gz
  rpmbuild -ba ${RPM_DIR}/SPECS/firewalld.spec
}

function clearWorkDir(){
  cd ${WORK_DIR}
  mkdir -pv _output
  \cp -a ${RPM_DIR}/RPMS/noarch/*.rpm  ${WORK_DIR}/_output/
  rm -fr ${RPM_DIR}
}

function MAIN(){
  echo -e "\033[41;05m Install dependencies packages. \033[0m"
  installRequirementsPackage
  echo -e "\033[41;05m Start Create Work Dir. \033[0m"
  initWorkDir
  echo -e "\033[41;05m Start Build Packages. \033[0m"
  generatePackage
  echo -e "\033[41;05m clear work dir. \033[0m"
  clearWorkDir
}

MAIN