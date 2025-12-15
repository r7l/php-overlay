# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Eases the creation of beautiful and testable command line interfaces"
HOMEPAGE="https://github.com/symfony/console"
SRC_URI="https://github.com/symfony/console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/console-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="dev-php/theseer-autoload"
RDEPEND="
	>=dev-lang/php-8.1:*
	dev-php/fedora-autoloader
	dev-php/symfony-deprecation-contracts
	dev-php/symfony-polyfill-mbstring
	dev-php/symfony-service-contracts
	dev-php/symfony-string
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

	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/Psr/Container/autoload.php",
	"${VENDOR_DIR}/Symfony/Deprecation-Contracts/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Ctype/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Intl-Grapheme/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Intl-Normalizer/autoload.php",
	"${VENDOR_DIR}/Symfony/Polyfill-Mbstring/autoload.php",
	"${VENDOR_DIR}/Symfony/Service-Contracts/autoload.php",
	"${VENDOR_DIR}/Symfony/String/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Symfony/Console"
	doins -r Application.php Attribute CI Color.php Command CommandLoader Completion ConsoleEvents.php Cursor.php DataCollector Debug DependencyInjection Descriptor Event EventListener Exception Formatter Helper Input Logger Messenger Output Question Resources SignalRegistry SingleCommandApplication.php Style Terminal.php Tester autoload.php || die
}
