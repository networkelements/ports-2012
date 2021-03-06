# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit mate multilib

DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop."
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
KERNEL_IUSE="kernel_linux"
IUSE="libnotify opengl pam systemd consolekit $KERNEL_IUSE"

RDEPEND=">=x11-libs/gtk+-2.14.0:2
	>=mate-base/mate-desktop-1.5.3
	>=mate-base/mate-menus-1.5.0
	>=dev-libs/glib-2.15:2
	>=mate-base/libmatekbd-1.5.0
	>=dev-libs/dbus-glib-0.71
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	opengl? ( virtual/opengl )
	pam? ( virtual/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	!!<gnome-extra/gnome-screensaver-3.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
	>=mate-base/mate-common-1.2.2
	systemd? ( sys-apps/systemd )
	consolekit? ( sys-auth/consolekit )"

src_prepare() {
	#epatch "${FILESDIR}/${PN}-1.2.0-prevent-multiple-instances.patch"
	# Fix QA warnings due to missing includes in popsquares
	epatch "${FILESDIR}/${PN}-1.2.0-fix-popsquares-includes.patch"
	# Fix libgl typo in configure.ac
	epatch "${FILESDIR}/${PN}-1.2.0-fix-with-libgl.patch"
	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
	# Fix forgotten gnome->mate rename
	sed -i 's:org.gnome:org.mate:' po/POTFILES.in || die "sed failed"
	# Make tests work
	sed -i '6 a\data/lock-dialog-default.ui' po/POTFILES.in || die "sed failed"
	mate_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	mate_src_configure \
		$(use_enable debug) \
		$(use_with libnotify) \
		$(use_with opengl libgl) \
		$(use_enable pam) \
		$(use_with systemd) \
		$(use_with consolekit console-kit) \
		--enable-locking \
		--with-xf86gamma-ext \
		--with-kbd-layout-indicator \
		--with-xscreensaverdir=/usr/share/xscreensaver/config \
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver
}

src_install() {
	mate_src_install

	# Install the conversion script in the documentation
	dodoc "${S}/data/migrate-xscreensaver-config.sh"
	dodoc "${S}/data/xscreensaver-config.xsl"

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# http://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms u+s /usr/libexec/mate-screensaver-dialog
	fi
}

pkg_postinst() {
	mate_pkg_postinst

	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "gnome-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
		echo
	fi

	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.${PORTAGE_COMPRESS}"
}
