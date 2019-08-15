#!/bin/bash

# Avoid fetching portage in wrong place:
# !!! Section 'gentoo' in repos.conf has location attribute set to nonexistent directory: '/var/db/repos/gentoo'
# !!! Invalid Repository Location (not a dir): '/var/db/repos/gentoo'
sed -e 's:PORTDIR.*:PORTDIR="/usr/portage":g' -i /etc/portage/make.conf

mkdir -p /etc/portage/repos.conf/
echo "[DEFAULT]
main-repo = gentoo

[gentoo]
location = /usr/portage
sync-type = rsync
sync-uri = rsync://rsync.europe.gentoo.org/gentoo-portage
" > /etc/portage/repos.conf/gentoo.conf
