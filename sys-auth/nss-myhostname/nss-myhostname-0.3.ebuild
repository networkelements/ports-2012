# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss-myhostname/nss-myhostname-0.3.ebuild,v 1.15 2013/12/23 16:24:06 ago Exp $

EAPI="4"

DESCRIPTION="Name Service Switch module for resolving the local hostname"
HOMEPAGE="http://0pointer.de/lennart/projects/nss-myhostname/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~ia64 ppc ppc64 sparc x86"
IUSE=""

COMMON_DEPEND=""
RDEPEND="${COMMON_DEPEND}
	!>=sys-apps/systemd-197"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	# The documentation in doc/ is just the README file in other formats
	sed -e 's:SUBDIRS *= *doc:SUBDIRS =:' -i Makefile.{am,in} ||
		die "sed failed"
}

src_configure() {
	econf --disable-lynx
}

pkg_postinst() {
	elog "You must modify your name service switch lookup file to enable"
	elog "nss-myhostname. To do so, add 'myhostname' to the hosts line in"
	elog "/etc/nsswitch.conf"
	elog
	elog "An example hosts line looks like this:"
	elog "hosts:      files dns myhostname"
	elog
}
