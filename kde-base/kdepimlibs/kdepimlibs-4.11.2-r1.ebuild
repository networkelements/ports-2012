# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepimlibs/kdepimlibs-4.11.2-r1.ebuild,v 1.5 2013/12/11 20:27:09 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps."
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug ldap prison"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	!kde-misc/akonadi-social-utils
	$(add_kdebase_dep nepomuk-core)
	$(add_kdebase_dep kdelibs 'semantic-desktop')
	>=app-crypt/gpgme-1.1.6
	>=app-office/akonadi-server-1.10.1
	>=dev-libs/boost-1.35.0-r5:=
	dev-libs/libgpg-error
	>=dev-libs/libical-0.43
	dev-libs/cyrus-sasl
	>=dev-libs/qjson-0.8.1
	media-libs/phonon
	x11-misc/shared-mime-info
	prison? ( media-libs/prison )
	ldap? ( net-nds/openldap )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.9.1-boostincludes.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_find_package ldap)
		$(cmake-utils_use_find_package prison)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install
	rm "${ED}"/usr/share/apps/cmake/modules/FindQJSON.cmake
	rm "${ED}"/usr/share/apps/cmake/modules/FindQtOAuth.cmake #Collides with	net-im/choqok
}
