# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pnmixer/pnmixer-0.6_pre20111213.ebuild,v 1.6 2013/03/03 17:32:19 vincent Exp $

EAPI=5

inherit autotools eutils gnome2-utils

DESCRIPTION="Alsa volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
SRC_URI="http://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug libnotify"

RDEPEND="media-libs/alsa-lib
	x11-libs/gtk+:2
	x11-libs/libX11
	libnotify? ( x11-libs/libnotify )"
DEPEND="sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{build,desktopfile}.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with libnotify)
}

src_install() {
	default
	newicon -s 128 pixmaps/${PN}-about.png ${PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
