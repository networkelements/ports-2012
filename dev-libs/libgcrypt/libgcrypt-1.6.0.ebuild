# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgcrypt/libgcrypt-1.6.0.ebuild,v 1.2 2013/12/27 20:35:32 grobian Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
WANT_AUTOMAKE=1.12

inherit autotools-utils flag-o-matic

DESCRIPTION="General purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/libgcrypt/${P}.tar.bz2
	ftp://ftp.gnupg.org/gcrypt/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 MIT"
SLOT="0/20" # subslot = soname major version
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.11"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-uscore.patch
	"${FILESDIR}"/${PN}-multilib-syspath.patch
)

src_configure() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		# ASM code uses GNU ELF syntax, divide in particular, we need to
		# allow this via ASFLAGS, since we don't have a flag-o-matic
		# function for that, we'll have to abuse cflags for this
		append-cflags -Wa,--divide
	fi
	local myeconfargs=(
		--disable-padlock-support # bug 201917
		--disable-dependency-tracking
		--enable-noexecstack
		--disable-O-flag-munging
		$(use_enable static-libs static)

		# disabled due to various applications requiring privileges
		# after libgcrypt drops them (bug #468616)
		--without-capabilities

		# http://trac.videolan.org/vlc/ticket/620
		# causes bus-errors on sparc64-solaris
		$([[ ${CHOST} == *86*-darwin* ]] && echo "--disable-asm")
		$([[ ${CHOST} == sparcv9-*-solaris* ]] && echo "--disable-asm")
	)
	autotools-utils_src_configure
}
