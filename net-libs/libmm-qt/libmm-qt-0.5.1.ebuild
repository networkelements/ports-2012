# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmm-qt/libmm-qt-0.5.1.ebuild,v 1.1 2013/10/15 22:20:57 johu Exp $

EAPI=5

KDE_REQUIRED="never"
inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://kde/unstable/modemmanager-qt/${PV}/src/${P}.tar.xz"
else
	KEYWORDS=""
fi

DESCRIPTION="Modemmanager bindings for Qt"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libmm-qt"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	net-misc/mobile-broadband-provider-info
	>=net-misc/networkmanager-0.9.0[modemmanager]
"
DEPEND="${RDEPEND}"
