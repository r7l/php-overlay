# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Helper class to locate a Drupal installation."
HOMEPAGE="https://github.com/webflo/drupal-finder"
SRC_URI="https://github.com/webflo/drupal-finder/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/drupal-finder-${PV}"

LICENSE="GPL-2.0-or-later"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-autoload"
RDEPEND="
	>=dev-lang/php-8.1:*
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir . \
		. \
		|| die
}

src_install() {
	insinto "/usr/share/php/Webflo/Drupal-Finder"
	doins -r src autoload.php || die
}
