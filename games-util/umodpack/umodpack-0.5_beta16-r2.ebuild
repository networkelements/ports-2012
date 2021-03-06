# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/umodpack/umodpack-0.5_beta16-r2.ebuild,v 1.1 2013/09/01 15:57:52 idella4 Exp $

EAPI=5

inherit perl-module toolchain-funcs

MY_P=${P/_beta/b}
DESCRIPTION="portable and useful [un]packer for Unreal Tournament's Umod files"
HOMEPAGE="http://www.oldunreal.com/wiki/index.php?title=UmodPack"
SRC_URI="mirror://gentoo/${MY_P}-allinone.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="tk"

DEPEND="virtual/perl-IO-Compress
	dev-perl/Archive-Zip
	dev-perl/Tie-IxHash
	tk? ( dev-perl/perl-tk )"

S=${WORKDIR}/${MY_P}
SRC_TEST="do parallel"

src_prepare() {
	# remove the stupid perl modules since we already installed em
	rm -rf {Archive-Zip,Compress-Zlib,Tie-IxHash,Tk}* || die
}

src_compile() {
	perl-module_src_compile

	cd umr-0.3 || die
	emake DEBUG=0 CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	mydoc="Changes"
	perl-module_src_install
	dobin umod umr-0.3/umr
	if use tk ; then
		dobin xumod
	fi
}
