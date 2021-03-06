# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/plplot/plplot-5.9.10-r1.ebuild,v 1.2 2013/11/16 08:28:49 dirtyepic Exp $

EAPI=5

WX_GTK_VER="2.8"
FORTRAN_NEEDED=fortran
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils fortran-2 cmake-utils python-single-r1 toolchain-funcs \
	virtualx wxwidgets java-pkg-opt-2 multilib

DESCRIPTION="Multi-language scientific plotting library"
HOMEPAGE="http://plplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/11"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="ada cairo cxx doc +dynamic examples fortran gd java jpeg latex lua
	ocaml octave pdf perl png python qhull qt4 shapefile svg tcl test
	threads tk truetype wxwidgets X"

RDEPEND="
	ada? ( virtual/gnat )
	cairo? ( x11-libs/cairo[svg?,X?] )
	java? ( >=virtual/jre-1.5 )
	gd? ( media-libs/gd[jpeg?,png?] )
	latex? ( virtual/latex-base app-text/ghostscript-gpl )
	lua? ( dev-lang/lua )
	ocaml? (
		dev-lang/ocaml
		dev-ml/camlidl
		cairo? ( dev-ml/cairo-ocaml[gtk] ) )
	octave? ( sci-mathematics/octave )
	pdf? ( media-libs/libharu )
	perl? ( dev-perl/PDL dev-perl/XML-DOM )
	python? (
		dev-python/numpy[${PYTHON_USEDEP}]
		qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] ) )
	qhull? ( media-libs/qhull )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtsvg:4 )
	shapefile? ( sci-libs/shapelib )
	tcl? ( dev-lang/tcl dev-tcltk/itcl
		tk? ( dev-lang/tk dev-tcltk/itk ) )
	truetype? (
		media-fonts/freefont
		media-libs/lasi
		gd? ( media-libs/gd[truetype] ) )
	wxwidgets? ( x11-libs/wxGTK:2.8[X] x11-libs/agg[truetype?] )
	X? ( x11-libs/libX11 x11-libs/libXau x11-libs/libXdmcp )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 dev-lang/swig )
	ocaml? ( dev-ml/findlib )
	python? ( dev-lang/swig )
	test? ( media-fonts/font-misc-misc
			media-fonts/font-cursor-misc )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) qt4? ( dynamic ) test? ( latex )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	# path for python independent of python version
	epatch \
		"${FILESDIR}"/${PN}-5.9.6-python.patch \
		"${FILESDIR}"/${PN}-5.9.10-tcltk.patch \
		"${FILESDIR}"/${PN}-5.9.10-tcl86.patch \
		"${FILESDIR}"/${PN}-5.9.10-haru.patch

	# avoid installing license
	sed -i -e '/COPYING.LIB/d' CMakeLists.txt || die
	# prexify hard-coded /usr/include in cmake modules
	sed -i \
		-e "s:/usr/include:${EPREFIX}/usr/include:g" \
		-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:/usr/share:${EPREFIX}/usr/share:g" \
		cmake/modules/*.cmake || die
	# change default install directories for doc and examples
	sed -i \
		-e 's:${DATA_DIR}/examples:${DOC_DIR}/examples:g' \
		$(find "${S}" -name CMakeLists.txt) || die
	sed -i \
		-e 's:${VERSION}::g' \
		-e "s:doc/\${PACKAGE}:doc/${PF}:" \
		cmake/modules/instdirs.cmake || die
	java-utils-2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDEFAULT_ALL_DEVICES=ON
		-DTEST_DYNDRIVERS=OFF
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DENABLE_d=OFF
		$(cmake-utils_use_build doc DOX_DOC)
		$(cmake-utils_use_build test)
		$(cmake-utils_use_has python NUMPY)
		$(cmake-utils_use_has shapefile SHAPELIB)
		$(cmake-utils_use_with truetype FREETYPE)
		$(cmake-utils_use_enable ada)
		$(cmake-utils_use_enable cxx)
		$(cmake-utils_use_enable dynamic DYNDRIVERS)
		$(cmake-utils_use_enable fortran f77)
		$(cmake-utils_use_enable java)
		$(cmake-utils_use_enable lua)
		$(cmake-utils_use_enable ocaml)
		$(cmake-utils_use_enable octave)
		$(cmake-utils_use_enable perl pdl)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable qt4 qt)
		$(cmake-utils_use_enable tcl)
		$(cmake-utils_use_enable tcl itcl)
		$(cmake-utils_use_enable tk)
		$(cmake-utils_use_enable tk itk)
		$(cmake-utils_use_enable wxwidgets)
		$(cmake-utils_use threads PL_HAVE_PTHREAD)
		$(cmake-utils_use qhull PL_HAVE_QHULL)
		$(cmake-utils_use qt4 PLD_aqt)
		$(cmake-utils_use qt4 PLD_bmpqt)
		$(cmake-utils_use qt4 PLD_epsqt)
		$(cmake-utils_use qt4 PLD_extqt)
		$(cmake-utils_use qt4 PLD_jpgqt)
		$(cmake-utils_use qt4 PLD_memqt)
		$(cmake-utils_use qt4 PLD_pdfqt)
		$(cmake-utils_use qt4 PLD_pngqt)
		$(cmake-utils_use qt4 PLD_ppmqt)
		$(cmake-utils_use qt4 PLD_svgqt)
		$(cmake-utils_use qt4 PLD_qtwidget)
		$(cmake-utils_use qt4 PLD_tiffqt)
		$(cmake-utils_use cairo PLD_extcairo)
		$(cmake-utils_use cairo PLD_memcairo)
		$(cmake-utils_use cairo PLD_pdfcairo)
		$(cmake-utils_use cairo PLD_pngcairo)
		$(cmake-utils_use cairo PLD_pscairo)
		$(cmake-utils_use cairo PLD_svgcairo)
		$(cmake-utils_use cairo PLD_wincairo)
		$(cmake-utils_use cairo PLD_xcairo)
		$(cmake-utils_use tk PLD_ntk)
		$(cmake-utils_use tk PLD_tk)
		$(cmake-utils_use tk PLD_tkwin)
		$(cmake-utils_use gd PLD_gif)
		$(cmake-utils_use gd PLD_jpeg)
		$(cmake-utils_use gd PLD_png)
		$(cmake-utils_use pdf PLD_pdf)
		$(cmake-utils_use latex PLD_ps)
		$(cmake-utils_use latex PLD_pstex)
		$(cmake-utils_use truetype PLD_psttf)
		$(cmake-utils_use svg PLD_svg)
		$(cmake-utils_use wxwidgets PLD_wxpng)
		$(cmake-utils_use wxwidgets PLD_wxwidgets)
		$(cmake-utils_use X PLD_xwin)
	)

	[[ $(tc-getFC) != *g77 ]] && \
		mycmakeargs+=(
		$(cmake-utils_use_enable fortran f95)
	)

	use truetype && mycmakeargs+=(
		-DPL_FREETYPE_FONT_PATH:PATH="${EPREFIX}/usr/share/fonts/freefont"
	)
	use shapefile && mycmakeargs+=(
		-DSHAPELIB_INCLUDE_DIR="${EPREFIX}/usr/include/libshp"
	)
	use python && mycmakeargs+=( $(cmake-utils_use_enable qt4 pyqt4) )
	use doc && mycmakeargs+=( -DPREBUILT_DOC=ON )
	cmake-utils_src_configure

	# clean up bloated pkg-config files (help linking properly on prefix)
	sed -i \
		-e "/Cflags/s:-I\(${EPREFIX}\|\)/usr/include[[:space:]]::g" \
		-e "/Libs/s:-L\(${EPREFIX}\|\)/usr/lib\(64\|\)[[:space:]]::g" \
		-e "s:${LDFLAGS}::g" \
		"${BUILD_DIR}"/pkgcfg/*pc || die
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null
	Xemake test || die "tests failed"
	popd > /dev/null
}

src_install() {
	cmake-utils_src_install
	use examples || rm -r "${ED}"/usr/share/doc/${PF}/examples
	#use doc && dohtml -r doc/docbook/src/*
	if use java; then
		rm -r "${ED}"/usr/share/java "${ED}"/usr/$(get_libdir)/jni  || die
		java-pkg_dojar "${BUILD_DIR}"/examples/java/${PN}.jar
		java-pkg_doso "${BUILD_DIR}"/bindings/java/plplotjavac_wrap.so
	fi
}
