#!/bin/bash

eselect python cleanup

# Upgrading packages
rsync -av "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/" && ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept && \
equo up && equo u && \
echo -5 | equo conf update

# Remove compilation tools
equo rm --nodeps --force-system automake bison yacc gcc localepurge

equo i base-gcc

# Writing package list file
equo q list installed -qv > /etc/sabayon-pkglist

equo cleanup
