# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/timecop/timecop-0.6.0.ebuild,v 1.2 2013/12/15 17:10:05 zerochaos Exp $

EAPI=5

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A gem providing 'time travel' and 'time freezing' capabilities"
HOMEPAGE="http://github.com/jtrupiano/timecop"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' -e '/History.rdoc/d' Rakefile || die
	sed -i -e '/rubygems/ a\gem "test-unit"' test/test_helper.rb || die
}
each_ruby_prepare() {
	sed -i -e "/bin\/sh/ a\RUBY='${RUBY}'" test/run_tests.sh || die
}
