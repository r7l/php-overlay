# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Executes commands in sub-processes"
HOMEPAGE="https://github.com/symfony/process"
SRC_URI="https://github.com/symfony/process/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/process-${PV}"

LICENSE="MIT"
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
	insinto "/usr/share/php/Symfony/Process"
	doins -r Exception ExecutableFinder.php InputStream.php Messenger PhpExecutableFinder.php PhpProcess.php PhpSubprocess.php Pipes Process.php ProcessUtils.php autoload.php || die
}
