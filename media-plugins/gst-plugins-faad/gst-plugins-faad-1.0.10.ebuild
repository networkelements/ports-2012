# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faad/gst-plugins-faad-1.0.10.ebuild,v 1.9 2013/10/22 07:20:41 ago Exp $

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/faad2"
DEPEND="${RDEPEND}"
