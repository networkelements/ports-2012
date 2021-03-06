# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ripole/ripole-0.2.2.ebuild,v 1.8 2013/06/29 19:26:12 ago Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Program/library to pull out attachment from OLE2 data files"
HOMEPAGE="http://www.pldaniels.com/ripole/"
SRC_URI="http://www.pldaniels.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.0-ldflags.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin ripole
	dodoc CHANGELOG README CONTRIBUTORS
}
