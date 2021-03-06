# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/notes/notes-0.23.2.ebuild,v 1.1 2013/09/01 23:14:24 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: easy note taking in vim"
HOMEPAGE="http://peterodding.com/code/vim/notes/"
SRC_URI="https://github.com/xolox/vim-notes/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-vim/vim-misc-1.8.5"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/vim-${P}

src_prepare() {
	# remove unnecessary files
	rm addon-info.json INSTALL.md README.md || die

	python_fix_shebang .
}
