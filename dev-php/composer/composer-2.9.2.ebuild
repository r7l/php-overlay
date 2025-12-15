# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Composer helps you declare, manage and install dependencies of PHP projects. It ensures you have the right stack everywhere."
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/composer/composer/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/composer-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-autoload"
RDEPEND="
	>=dev-lang/php-7.4:*
	dev-php/fedora-autoloader
	dev-php/ca-bundle
	dev-php/class-map-generator
	dev-php/justinrainbow-json-schema
	dev-php/metadata-minifier
	dev-php/pcre
	dev-php/psr-log
	dev-php/react-promise
	dev-php/seld-jsonlint
	dev-php/seld-phar-utils
	dev-php/seld-signal-handler
	dev-php/semver
	dev-php/spdx-licenses
	dev-php/symfony-console
	dev-php/symfony-filesystem
	dev-php/symfony-finder
	dev-php/symfony-polyfill-php73
	dev-php/symfony-polyfill-php80
	dev-php/symfony-polyfill-php81
	dev-php/symfony-polyfill-php84
	dev-php/symfony-process
	dev-php/xdebug-handler
"

PATCHES=(
	"${FILESDIR}"/autoload.patch
	"${FILESDIR}"/explain-non-standard-install.patch
)

src_prepare() {
	default

	mkdir vendor || die

	phpab \
		--quiet \
		--output vendor/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src \
		|| die

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/Composer/Ca-Bundle/autoload.php",
	"${VENDOR_DIR}/Composer/Class-Map-Generator/autoload.php",
	"${VENDOR_DIR}/Justinrainbow/Json-Schema/autoload.php",
	"${VENDOR_DIR}/Marc-mabe/Php-Enum/autoload.php",
	"${VENDOR_DIR}/Composer/Metadata-Minifier/autoload.php",
	"${VENDOR_DIR}/Composer/Pcre/autoload.php",
	"${VENDOR_DIR}/Psr/Container/autoload.php",
	"${VENDOR_DIR}/Psr/Log/autoload.php",
	"${VENDOR_DIR}/React/Promise/autoload.php",
	"${VENDOR_DIR}/Seld/Jsonlint/autoload.php",
	"${VENDOR_DIR}/Seld/Phar-Utils/autoload.php",
	"${VENDOR_DIR}/Seld/Signal-Handler/autoload.php",
	"${VENDOR_DIR}/Composer/Semver/autoload.php",
	"${VENDOR_DIR}/Composer/Spdx-Licenses/autoload.php",
	"${VENDOR_DIR}/Symfony/Console/autoload.php",
	"${VENDOR_DIR}/Symfony/Deprecation-Contracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Filesystem/autoload.php",
	"${VENDOR_DIR}/Symfony/Finder/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Intl-Grapheme/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Intl-Normalizer/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Php73/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Php80/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Php81/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Php84/autoload.php",
	"${VENDOR_DIR}/Symfony/Process/autoload.php",
	"${VENDOR_DIR}/Symfony/Service-Contracts/autoload.php",
	"${VENDOR_DIR}/Symfony/String/autoload.php",
	"${VENDOR_DIR}/Composer/Xdebug-Handler/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/composer"
	doins -r LICENSE res src vendor

	insinto "/usr/share/composer"
	doins -r bin
	fperms +x "/usr/share/composer/bin"/composer

	dosym "/usr/share/composer/bin/composer" "/usr/bin/composer"
}
