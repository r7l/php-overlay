# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official version of pdepend to be handled with Composer"
HOMEPAGE="https://github.com/pdepend/pdepend"
SRC_URI="https://github.com/pdepend/pdepend/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/symfony-dependency-injection
	dev-php/symfony-filesystem
	dev-php/symfony-config"

src_prepare() {
	default

	sed -i "s/\.\.\/vendor\/autoload.php/autoload.php/g" "${S}"/src/bin/pdepend*

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die

	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/Fedora/Autoloader/autoload.php',
	'/usr/share/php/Symfony/Component/Config/autoload.php',
	'/usr/share/php/Symfony/Component/DependencyInjection/autoload.php',
	'/usr/share/php/Symfony/Component/Filesystem/autoload.php'
]);
EOF

}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r src/main src/bin/pdepend.php autoload.php

	exeinto "/usr/share/${PN}/bin"
	doexe "src/bin/${PN}"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"
}
