# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

PYTHON_COMPAT=( python2_7 )

inherit gnome2 multilib python-r1 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

IUSE="X gtk3 +introspection startup-notification"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.36:2
	x11-libs/cairo:0
	!gtk3? ( >=x11-libs/gdk-pixbuf-2.4:2
			>=x11-libs/gtk+-2.24:2
			>=dev-libs/libunique-1:1
			)
	gtk3? ( x11-libs/gtk+:3
			dev-libs/libunique:3
			)
	>=x11-libs/gdk-pixbuf-2.4:2[introspection?]
	>=x11-libs/gtk+-2.24:2[introspection?]
	x11-libs/libX11:0
	>=x11-libs/libXrandr-1.3:0
	virtual/libintl:0
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )
	startup-notification? ( >=x11-libs/startup-notification-0.5:0 )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.2-r1
	>=gnome-base/dconf-0.13.4:0
	sys-devel/gettext:*
	>=x11-proto/randrproto-1.2:0
	x11-proto/xproto:0
	virtual/pkgconfig:*"

src_configure() {
	local use_gtk3
	use gtk3 && use_gtk3="${use_gtk3} --with-gtk=3.0"
	use !gtk3 && use_gtk3="${use_gtk3} --with-gtk=2.0"

	gnome2_src_configure \
		--enable-mate-about \
		$(use_with X x) \
		$(use_enable introspection) \
		$(use_enable startup-notification) \
		${use_gtk3}
}

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_install() {
	gnome2_src_install

#	python_replicate_script "${ED}"/usr/bin/mate-conf-import
}