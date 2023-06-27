# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Coder is a library to review Drupal code."
HOMEPAGE="https://github.com/pfrenssen/coder"
SRC_URI="https://github.com/pfrenssen/coder/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-php/theseer-Autoload
	dev-php/PHP_CodeSniffer"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/phpcs-variable-analysis
	dev-php/coding-standard
	dev-php/PHP_CodeSniffer
	dev-php/symfony-yaml"

S="${WORKDIR}/coder-${PV}"
MY_INSTALL_PATH="/usr/share/php/drupal/coder"
MY_CODESNIFFER_CONF="/usr/share/php/data/PHP/CodeSniffer/CodeSniffer.conf"

src_prepare() {
	default

	phpab \
		--quiet \
		--output autoload.php \
		--template fedora2 \
		--basedir coder_sniffer \
		coder_sniffer \
		|| die

	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/PHP/CodeSniffer/autoload.php',
	'/usr/share/php/PHPStan/PhpDocParser/autoload.php',
	'/usr/share/php/Symfony/Component/Yaml/autoload.php',
]);
EOF
}

src_install() {
	insinto "${MY_INSTALL_PATH}"
	doins -r coder_sniffer/* autoload.php
}

pkg_postinst() {

	# Create a new path list with current package
	local INSTALLED_PATHS="${MY_INSTALL_PATH}"

	if [ -f ${MY_CODESNIFFER_CONF} ]; then

		# Get existing paths into array
		local EXISTING_PATHS=$(grep 'installed_paths' ${MY_CODESNIFFER_CONF} | awk '{print $3}' | sed 's/^.//' | sed 's/..$//')
		local EXISTING_PATHS_ARRAY=($(echo ${EXISTING_PATHS} | tr "," "\n" ))

		# Check if we have the expected value installed already
		# Add paths to path list otherwise
		for EXISTING_PATH in "${EXISTING_PATHS_ARRAY[@]}"; do
			if [ "${EXISTING_PATH}" == "${MY_INSTALL_PATH}" ]; then
				echo "Path already intalled to PHPCS"
				return 0
			fi
			INSTALLED_PATHS="${INSTALLED_PATHS},${EXISTING_PATH}"
		done

	fi

	# Install the new list of paths
	phpcs --config-set installed_paths ${INSTALLED_PATHS} || die "Unable to update PHPCS configu"

}

pkg_postrm() {

	if [ -f ${MY_CODESNIFFER_CONF} ]; then

		# Get existing paths into array
		local EXISTING_PATHS=$(grep 'installed_paths' ${MY_CODESNIFFER_CONF} | awk '{print $3}' | sed 's/^.//' | sed 's/..$//')
		local EXISTING_PATHS_ARRAY=($(echo ${EXISTING_PATHS} | tr "," "\n" ))

		# Create a new empty path list
		local INSTALLED_PATHS=""

		# Add any path that except this package
		for EXISTING_PATH in "${EXISTING_PATHS_ARRAY[@]}"; do
			if [ "${EXISTING_PATH}" != "${MY_INSTALL_PATH}" ]; then
				if [ -z "${INSTALLED_PATHS}" ]; then
					INSTALLED_PATHS="${EXISTING_PATH}"
				else
					INSTALLED_PATHS="${INSTALLED_PATHS},${EXISTING_PATH}"
				fi
			fi
		done

		if [ ! -z ${INSTALLED_PATHS} ]; then
			# Install the new list of paths
			phpcs --config-set installed_paths ${INSTALLED_PATHS} || die "Unable to update PHPCS configu"
		else
			# Delete config
			rm ${MY_CODESNIFFER_CONF}
		fi

	fi

}
