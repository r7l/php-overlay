# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool and library to generate autoload code."
HOMEPAGE="https://github.com/theseer/Autoload"
SRC_URI="https://github.com/theseer/Autoload/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Autoload-${PV}"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-lang/php-5.3:*
	!dev-php/theseer-Autoload
	dev-php/theseer-directoryscanner
	dev-php/zetacomponents-console-tools
"

PATCHES=(
	"${FILESDIR}"/theseer-autoload-autoload.php.patch
)

src_prepare() {
	default

	# Set version
	sed -i \
		-e "s/%development%/${PV}/" \
		phpab.php \
		composer/bin/phpab \
		|| die

	cp --target-directory src/templates/ci \
		"${FILESDIR}"/fedora.php.tpl \
		"${FILESDIR}"/fedora2.php.tpl \
		|| die

	# Mimick layout to bootstrap phpab
	mkdir --parents \
		vendor/theseer/directoryscanner \
		vendor/zetacomponents/console-tools \
		|| die

	ln -s "${EPREFIX}/usr/share/php/Theseer/Directoryscanner/src" vendor/theseer/directoryscanner/src || die
	ln -s "${EPREFIX}/usr/share/php/Zetacomponents/Console-Tools/src" vendor/zetacomponents/console-tools/src  || die

	./phpab.php \
		--output src/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src || die
}

src_install() {
	insinto /usr/share/php/Theseer/Autoload
	doins -r src/*

	insinto /usr/share/php/Theseer/Autoload
	doins -r "${S}"/composer/bin
	fperms +x /usr/share/php/Theseer/Autoload/bin/phpab

	dosym /usr/share/php/Theseer/Autoload/bin/phpab /usr/bin/phpab

	einstalldocs
}
