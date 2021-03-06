# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipcalc/ipcalc-1.1.1.ebuild,v 1.1 2013/10/28 07:05:07 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="IP subnet calculator"
HOMEPAGE="http://pypi.python.org/pypi/ipcalc/"
SRC_URI="mirror://pypi/i/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""
