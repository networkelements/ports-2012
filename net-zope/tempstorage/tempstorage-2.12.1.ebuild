# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="A RAM-based storage for ZODB"
HOMEPAGE="http://pypi.python.org/pypi/tempstorage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"
IUSE="test"

RDEPEND="$(python_abi_depend ">=net-zope/zodb-3.9.0")"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/tempstorage/tests"
	}
	python_execute_function -q delete_tests
}