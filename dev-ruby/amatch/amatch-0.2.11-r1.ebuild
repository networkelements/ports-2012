# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amatch/amatch-0.2.11-r1.ebuild,v 1.1 2013/11/02 20:01:38 mrueg Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Approximate Matching Extension for Ruby"
HOMEPAGE="http://flori.github.com/amatch/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/tins-0.3"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext V=1
	cp ext/amatch_ext$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/* || die
}
