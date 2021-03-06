# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/peewee/peewee-2.1.4.ebuild,v 1.3 2013/08/17 04:30:56 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

RESTRICT="test" # wants to access the local PG instance - not OK

inherit distutils-r1

DESCRIPTION="Small python ORM"
HOMEPAGE="https://github.com/coleifer/peewee/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/apsw[${PYTHON_USEDEP}]
		dev-python/psycopg[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
