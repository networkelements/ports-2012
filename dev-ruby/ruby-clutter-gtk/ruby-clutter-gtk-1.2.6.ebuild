# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-clutter-gtk/ruby-clutter-gtk-1.2.6.ebuild,v 1.1 2013/05/04 13:08:53 naota Exp $

EAPI=4
USE_RUBY="ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="~amd64"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gtk

DEPEND="${DEPEND} media-libs/clutter-gtk"
RDEPEND="${RDEPEND} media-libs/clutter-gtk"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-gtk3-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}
