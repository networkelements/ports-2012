# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-reaction/quake3-reaction-3.2.ebuild,v 1.4 2009/10/07 13:23:10 nyhm Exp $

EAPI=2

MOD_DESC="port of Action Quake 2 to Quake 3: Arena"
MOD_NAME="Reaction"
MOD_DIR="rq3"
MOD_ICON="reaction-4.ico"

inherit games games-mods

HOMEPAGE="http://www.rq3.com/"
SRC_URI="http://www.rq3.com/ReactionQuake3-v${PV}-Full.zip"

LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated opengl"
