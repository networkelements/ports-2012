# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups-filters/cups-filters-9999.ebuild,v 1.43 2013/12/27 22:09:41 dilfridge Exp $

EAPI=5

GENTOO_DEPEND_ON_PERL=no

inherit base eutils perl-module autotools systemd

if [[ "${PV}" == "9999" ]] ; then
	inherit bzr
	EBZR_REPO_URI="http://bzr.linuxfoundation.org/openprinting/cups-filters"
	KEYWORDS=""
else
	SRC_URI="http://www.openprinting.org/download/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~m68k-mint"
fi
DESCRIPTION="Cups PDF filters"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/openprinting/pdfasstandardprintjobformat"

LICENSE="MIT GPL-2"
SLOT="0"
IUSE="jpeg perl png static-libs tiff zeroconf"

RDEPEND="
	>=app-text/ghostscript-gpl-9.09
	app-text/poppler:=[cxx,jpeg?,lcms,tiff?,xpdf-headers(+)]
	>=app-text/qpdf-3.0.2:=
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	>net-print/cups-1.5.9999
	!<=net-print/cups-1.5.9999
	sys-devel/bc
	sys-libs/zlib
	jpeg? ( virtual/jpeg:0 )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	base_src_prepare
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable zeroconf avahi) \
		$(use_enable static-libs static) \
		--with-fontdir="fonts/conf.avail" \
		--with-pdftops=pdftops \
		--enable-imagefilters \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff) \
		--with-rcdir=no \
 		--with-browseremoteprotocols=DNSSD,CUPS \
		--without-php
}

src_compile() {
	default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_prep
		perl-module_src_compile
		popd > /dev/null
	fi
}

src_install() {
	default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_install
		fixlocalpod
		popd > /dev/null
	fi

	# workaround: some printer drivers still require pstoraster and pstopxl, bug #383831
	dosym /usr/libexec/cups/filter/gstoraster /usr/libexec/cups/filter/pstoraster
	dosym /usr/libexec/cups/filter/gstopxl /usr/libexec/cups/filter/pstopxl

	prune_libtool_files --all

	cp "${FILESDIR}"/cups-browsed.init.d "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/utils/cups-browsed.service || die
	fi

	doinitd "${T}"/cups-browsed
	systemd_dounit "${S}/utils/cups-browsed.service"
}

pkg_postinst() {
	perl-module_pkg_postinst

	elog "This version of cups-filters includes cups-browsed, a daemon that autodiscovers"
	elog "remote queues via avahi or cups-1.5 browsing protocol and adds them to your cups"
	elog "configuration. You may want to add it to your default runlevel."
}
