# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnome-nettool/gnome-nettool-3.8.1.ebuild,v 1.3 2013/12/08 19:19:06 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="Graphical front-ends to various networking command-line"
HOMEPAGE="https://git.gnome.org/browse/gnome-nettool/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.25.10:2
	gnome-base/libgtop:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.90.4:3
	x11-libs/pango
"
RDEPEND="${COMMON_DEPEND}
	|| (
		net-misc/iputils
		net-analyzer/tcptraceroute
		net-analyzer/traceroute
		sys-freebsd/freebsd-usbin )
	net-analyzer/nmap
	net-dns/bind-tools
	userland_GNU? ( net-misc/netkit-fingerd net-misc/whois )
	userland_BSD? ( net-misc/bsdwhois )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	gnome2_src_configure $(use_enable debug)
}
