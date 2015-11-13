FROM sabayon/gentoo-stage3-base-amd64
MAINTAINER mudler <mudler@sabayonlinux.org
COPY locale.gen /etc/locale.gen
RUN locale-gen
