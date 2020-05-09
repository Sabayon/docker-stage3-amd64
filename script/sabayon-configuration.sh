#!/bin/bash

# Setting locale.conf
for f in /etc/env.d/02locale /etc/locale.conf; do
    echo LANG=en_US.UTF-8 > "${f}"
    echo LANGUAGE=en_US.UTF-8 >> "${f}"
    echo LC_ALL=en_US.UTF-8 >> "${f}"
done

source /etc/profile

# Defyning /usr/local/portage configuration
mkdir /usr/local/portage
mkdir -p /usr/local/portage/metadata/
mkdir -p /usr/local/portage/profiles/
echo "masters = gentoo" > /usr/local/portage/metadata/layout.conf
echo "user_defined" > /usr/local/portage/profiles/repo_name

mkdir -p /etc/portage/package.keywords/
echo "app-admin/equo ~amd64
sys-apps/entropy ~amd64
=app-portage/portage-utils-0.87 ~amd64
" > /etc/portage/package.keywords/00-sabayon.package.keywords

mkdir -p /etc/portage/package.use/
echo "dev-lang/python sqlite
sys-apps/file python
dev-libs/openssl -bindist
net-misc/opessh -bindist
>=app-admin/equo-324-r2 -python_targets_python2_7
=sys-apps/portage-2.3.69 -python_targets_python2_7
" > /etc/portage/package.use/00-sabayon.package.use

eselect profile list
eselect profile set default/linux/amd64/17.1/systemd

# We use python3.6
echo "
PYTHON_SINGLE_TARGET=\"python3_6\"
PYTHON_TARGETS=\"python2_7 python3_6\"
" >> /etc/portage/make.conf

emerge layman -vt -j 3 || {
  echo "Error on emerge layman"
  exit 1
}

layman -f && layman -S

echo "y" | layman -a sabayon
echo "y" | layman -a sabayon-distro

sed -i 's/repos\.conf/make.conf/' /etc/layman/layman.cfg

layman-updater -R

echo "source /var/lib/layman/make.conf" >> /etc/portage/make.conf

# We use our portage
emerge -vt -j 3 --autounmask-write sys-apps/portage::sabayon-distro

gcc-config -c
gcc-config 1
. /etc/profile

# emerging equo and expect
FEATURE="-usersandbox -sandbox" PYTHON_TARGETS="python3_6" USE="ncurses" emerge -j -vt equo --autounmask-write || exit 1
emerge -j expect -tv || exit 1

# Remove sys-apps/openrc from gentoo stage3
emerge --unmerge sys-apps/openrc

# default for next stage(s)
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# set default shell
chsh -s /bin/bash

rm -rf /etc/make.profile

# removing workaround, it is fixed in Entropy
rm -rf /etc/init.d/functions.sh
