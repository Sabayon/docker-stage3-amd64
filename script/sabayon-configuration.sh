#!/bin/bash

# Setting locale.conf
for f in /etc/env.d/02locale /etc/locale.conf; do
    echo LANG=en_US.UTF-8 > "${f}"
    echo LANGUAGE=en_US.UTF-8 >> "${f}"
    echo LC_ALL=en_US.UTF-8 >> "${f}"
done

#echo "en_US.UTF-8 UTF-8 " >> /etc/locale.gen &&  locale-gen &&  eselect locale set en_US.utf8 && env-update && source /etc/profile

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


# emerging equo and expect
USE="ncurses" emerge -j -vt equo --autounmask-write || exit 1
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
