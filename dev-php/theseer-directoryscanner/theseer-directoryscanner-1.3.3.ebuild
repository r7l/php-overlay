# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A recursive directory scanner and filter"
HOMEPAGE="https://github.com/theseer/DirectoryScanner"
SRC_URI="https://github.com/theseer/DirectoryScanner/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/DirectoryScanner-${PV}"

LICENSE="BSD-2-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-lang/php-5.3:*
	!dev-php/theseer-DirectoryScanner
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	echo "<?php" > autoload.php
	echo "require_once \"${EPREFIX}/usr/share/php/Fedora/Autoloader/autoload.php\";" >> autoload.php

	echo "" >> autoload.php
	echo "\\Fedora\\Autoloader\\Autoload::addClassMap(array(" >> autoload.php
	echo "    'theseer\directoryscanner\directoryscanner' => '/src/directoryscanner.php'," >> autoload.php
	echo "    'theseer\directoryscanner\exception' => '/src/directoryscanner.php'," >> autoload.php
	echo "    'theseer\directoryscanner\filesonlyfilteriterator' => '/src/filesonlyfilter.php'," >> autoload.php
	echo "    'theseer\directoryscanner\includeexcludefilteriterator' => '/src/includeexcludefilter.php'," >> autoload.php
	echo "    'theseer\directoryscanner\phpfilteriterator' => '/src/phpfilter.php'," >> autoload.php
	echo "), __DIR__);" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/Theseer/Directoryscanner"
	doins -r *.php LICENSE samples src tests
}
