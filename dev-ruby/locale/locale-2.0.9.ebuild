# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/locale/locale-2.0.9.ebuild,v 1.2 2013/10/26 06:45:38 graaff Exp $

EAPI=5

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc/reference"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc doc/text/news.md"

RUBY_FAKEGEM_TASK_TEST="test"

inherit ruby-fakegem

DESCRIPTION="A pure ruby library which provides basic APIs for localization."
HOMEPAGE="https://github.com/ruby-gettext/locale"
LICENSE="|| ( Ruby GPL-2 )"
SRC_URI="https://github.com/ruby-gettext/locale/archive/${PV}.tar.gz -> ${P}-git.tgz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 dev-ruby/test-unit-rr )"

all_ruby_prepare() {
	sed -i -e '/notify/ s:^:#:' test/run-test.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# Avoid failing tests in the partial jruby
			# implementation. This may be dependeny on the specific
			# locales available or it may be an issue with Gentoo still
			# using jruby 1.6.
			sed -i -e '/test_locales/,/end/ s:^:#:' test/test_driver_jruby.rb || die
			;;
	esac
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die
	fi
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r samples || die
}
