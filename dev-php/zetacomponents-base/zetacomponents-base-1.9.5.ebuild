# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Base package provides the basic infrastructure that all packages rely on. Therefore every component relies on this package."
HOMEPAGE="https://github.com/zetacomponents/Base"
SRC_URI="https://github.com/zetacomponents/Base/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Base-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-lang/php-7.4:*
	!dev-php/zetacomponents-Base
	dev-php/fedora-autoloader
"

src_prepare() {
	default

	echo "<?php" > autoload.php
	echo "require_once \"${EPREFIX}/usr/share/php/Fedora/Autoloader/autoload.php\";" >> autoload.php

	echo "" >> autoload.php
	echo "\\Fedora\\Autoloader\\Autoload::addClassMap(array(" >> autoload.php
	echo "    'ezcbase' => '/src/base.php'," >> autoload.php
	echo "    'ezcbaseautoloadexception' => '/src/exceptions/autoload.php'," >> autoload.php
	echo "    'ezcbaseautoloadoptions' => '/src/options/autoload.php'," >> autoload.php
	echo "    'ezcbaseconfigurationinitializer' => '/src/interfaces/configuration_initializer.php'," >> autoload.php
	echo "    'ezcbasedoubleclassrepositoryprefixexception' => '/src/exceptions/double_class_repository_prefix.php'," >> autoload.php
	echo "    'ezcbaseexception' => '/src/exceptions/exception.php'," >> autoload.php
	echo "    'ezcbaseexportable' => '/src/interfaces/exportable.php'," >> autoload.php
	echo "    'ezcbaseextensionnotfoundexception' => '/src/exceptions/extension_not_found.php'," >> autoload.php
	echo "    'ezcbasefeatures' => '/src/features.php'," >> autoload.php
	echo "    'ezcbasefile' => '/src/file.php'," >> autoload.php
	echo "    'ezcbasefileexception' => '/src/exceptions/file_exception.php'," >> autoload.php
	echo "    'ezcbasefilefindcontext' => '/src/structs/file_find_context.php'," >> autoload.php
	echo "    'ezcbasefileioexception' => '/src/exceptions/file_io.php'," >> autoload.php
	echo "    'ezcbasefilenotfoundexception' => '/src/exceptions/file_not_found.php'," >> autoload.php
	echo "    'ezcbasefilepermissionexception' => '/src/exceptions/file_permission.php'," >> autoload.php
	echo "    'ezcbasefunctionalitynotsupportedexception' => '/src/exceptions/functionality_not_supported.php'," >> autoload.php
	echo "    'ezcbaseinit' => '/src/init.php'," >> autoload.php
	echo "    'ezcbaseinitcallbackconfiguredexception' => '/src/exceptions/init_callback_configured.php'," >> autoload.php
	echo "    'ezcbaseinitinvalidcallbackclassexception' => '/src/exceptions/invalid_callback_class.php'," >> autoload.php
	echo "    'ezcbaseinvalidparentclassexception' => '/src/exceptions/invalid_parent_class.php'," >> autoload.php
	echo "    'ezcbasemetadata' => '/src/metadata.php'," >> autoload.php
	echo "    'ezcbasemetadatapearreader' => '/src/metadata/pear.php'," >> autoload.php
	echo "    'ezcbasemetadatatarballreader' => '/src/metadata/tarball.php'," >> autoload.php
	echo "    'ezcbaseoptions' => '/src/options.php'," >> autoload.php
	echo "    'ezcbasepersistable' => '/src/interfaces/persistable.php'," >> autoload.php
	echo "    'ezcbasepropertynotfoundexception' => '/src/exceptions/property_not_found.php'," >> autoload.php
	echo "    'ezcbasepropertypermissionexception' => '/src/exceptions/property_permission.php'," >> autoload.php
	echo "    'ezcbaserepositorydirectory' => '/src/structs/repository_directory.php'," >> autoload.php
	echo "    'ezcbasesettingnotfoundexception' => '/src/exceptions/setting_not_found.php'," >> autoload.php
	echo "    'ezcbasesettingvalueexception' => '/src/exceptions/setting_value.php'," >> autoload.php
	echo "    'ezcbasestruct' => '/src/struct.php'," >> autoload.php
	echo "    'ezcbasevalueexception' => '/src/exceptions/value.php'," >> autoload.php
	echo "    'ezcbasewhateverexception' => '/src/exceptions/whatever.php'," >> autoload.php
	echo "), __DIR__);" >> autoload.php

}

src_install() {
	insinto "/usr/share/php/Zetacomponents/Base"
	doins -r *.php design docs src tests
}
