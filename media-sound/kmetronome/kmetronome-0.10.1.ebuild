# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmetronome/kmetronome-0.10.1.ebuild,v 1.3 2013/06/11 15:52:51 ago Exp $

EAPI=4
KDE_LINGUAS="cs de es fr tr"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="MIDI based metronome using ALSA sequencer"
HOMEPAGE="http://kmetronome.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	media-libs/alsa-lib
	media-sound/drumstick
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	mycmakeargs=(
		-DSTATIC_DRUMSTICK=OFF
	)

	kde4-base_src_configure
}
