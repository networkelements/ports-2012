# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/evented-spec/evented-spec-0.9.0.ebuild,v 1.3 2013/12/03 06:51:43 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit versionator ruby-fakegem

DESCRIPTION="A set of helpers to help you test your asynchronous code."
HOMEPAGE="https://github.com/ruby-amqp/evented-spec"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Tests require a running AMQP server and AMQP installed. Since
# currently AMQP is the only package using evented-spec we just skip the
# tests here altogether to avoid circular dependencies.
RESTRICT="test"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '/effin_utf8/ s:^:#:' spec/spec_helper.rb || die
}
