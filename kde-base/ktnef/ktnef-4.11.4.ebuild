# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktnef/ktnef-4.11.4.ebuild,v 1.2 2013/12/14 16:54:05 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A viewer for TNEF attachments."
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug"

DEPEND="
	>=app-office/akonadi-server-1.9.51
	$(add_kdebase_dep kdepimlibs)
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	akonadi/
"
