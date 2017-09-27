#!/bin/bash

# Setting locale.conf
for f in /etc/env.d/02locale /etc/locale.conf; do
    echo LANG=en_US.UTF-8 > "${f}"
    echo LANGUAGE=en_US.UTF-8 >> "${f}"
    echo LC_ALL=en_US.UTF-8 >> "${f}"
done

# Defyning /usr/local/portage configuration
mkdir /usr/local/portage
mkdir -p /usr/local/portage/metadata/
mkdir -p /usr/local/portage/profiles/
echo "masters = gentoo" > /usr/local/portage/metadata/layout.conf
echo "user_defined" > /usr/local/portage/profiles/repo_name

mkdir -p /etc/portage/package.keywords/
echo "app-admin/equo ~amd64
sys-apps/entropy ~amd64
" > /etc/portage/package.keywords/00-sabayon.package.keywords

mkdir -p /etc/portage/package.use/
echo "dev-lang/python sqlite
sys-apps/file python
" > /etc/portage/package.use/00-sabayon.package.use


echo "y" | layman -a sabayon-distro

echo "conf_type : make.conf" >>  /etc/layman/layman.cfg

layman-updater -R

echo "source /var/lib/layman/make.conf" >> /etc/portage/make.conf

eselect profile set default/linux/amd64/13.0

# Sad to face this issue still after 1.5yr, see https://bugs.gentoo.org/show_bug.cgi?id=504118
ln -s /lib64/gentoo/functions.sh /etc/init.d/functions.sh
gcc-config -c
gcc-config 1
. /etc/profile

# emerging equo and expect
USE="ncurses" emerge -j -vt equo app-admin/localepurge --autounmask-write || exit 1
emerge -j expect || exit 1

# Enforce choosing only python2.7 for now, cleaning others
eselect python set python2.7

# Specifying a gentoo profile
eselect profile set default/linux/amd64/13.0/desktop

# default for next stage(s)
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# set default shell
chsh -s /bin/bash

rm -rf /etc/make.profile

# removing workaround, it is fixed in Entropy
rm -rf /etc/init.d/functions.sh
