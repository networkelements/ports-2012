# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/print-manager/print-manager-4.11.2.ebuild,v 1.5 2013/12/11 20:27:32 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Manage print jobs and printers in KDE"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=net-print/cups-1.5.0[dbus]
"
RDEPEND="${DEPEND}
	!kde-base/printer-applet:4
	!kde-base/system-config-printer-kde:4
	!kde-misc/print-manager
	app-admin/system-config-printer-gnome
"
