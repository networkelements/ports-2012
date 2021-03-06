# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/fam/fam-0-r1.ebuild,v 1.1 2013/08/08 12:59:28 aballier Exp $

EAPI=5

inherit multilib-build

DESCRIPTION="A virtual package to choose between gamin and fam"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="|| ( app-admin/gamin[${MULTILIB_USEDEP}] app-admin/fam[${MULTILIB_USEDEP}] )"
