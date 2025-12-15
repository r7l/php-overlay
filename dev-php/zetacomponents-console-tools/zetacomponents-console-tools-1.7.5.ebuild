# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A set of classes to do different actions with the console (also called shell). It can render a progress bar, tables and a status bar and contains a class for parsing command line options."
HOMEPAGE="https://github.com/zetacomponents/ConsoleTools"
SRC_URI="https://github.com/zetacomponents/ConsoleTools/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ConsoleTools-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-lang/php-7.4:*
	!dev-php/zetacomponents-ConsoleTools
	dev-php/fedora-autoloader
	dev-php/zetacomponents-base
"

src_prepare() {
	default

	echo "<?php" > autoload.php
	echo "require_once \"${EPREFIX}/usr/share/php/Fedora/Autoloader/autoload.php\";" >> autoload.php

	echo "" >> autoload.php
	echo "\\Fedora\\Autoloader\\Autoload::addClassMap(array(" >> autoload.php
	echo "    'ezcconsoleargument' => '/src/input/argument.php'," >> autoload.php
	echo "    'ezcconsoleargumentalreadyregisteredexception' => '/src/exceptions/argument_already_registered.php'," >> autoload.php
	echo "    'ezcconsoleargumentexception' => '/src/exceptions/argument.php'," >> autoload.php
	echo "    'ezcconsoleargumentmandatoryviolationexception' => '/src/exceptions/argument_mandatory_violation.php'," >> autoload.php
	echo "    'ezcconsolearguments' => '/src/input/arguments.php'," >> autoload.php
	echo "    'ezcconsoleargumenttypeviolationexception' => '/src/exceptions/argument_type_violation.php'," >> autoload.php
	echo "    'ezcconsoledialog' => '/src/interfaces/dialog.php'," >> autoload.php
	echo "    'ezcconsoledialogabortexception' => '/src/exceptions/dialog_abort.php'," >> autoload.php
	echo "    'ezcconsoledialogoptions' => '/src/options/dialog.php'," >> autoload.php
	echo "    'ezcconsoledialogvalidator' => '/src/interfaces/dialog_validator.php'," >> autoload.php
	echo "    'ezcconsoledialogviewer' => '/src/dialog_viewer.php'," >> autoload.php
	echo "    'ezcconsoleexception' => '/src/exceptions/exception.php'," >> autoload.php
	echo "    'ezcconsoleinput' => '/src/input.php'," >> autoload.php
	echo "    'ezcconsoleinputhelpgenerator' => '/src/interfaces/input_help_generator.php'," >> autoload.php
	echo "    'ezcconsoleinputstandardhelpgenerator' => '/src/input/help_generators/standard.php'," >> autoload.php
	echo "    'ezcconsoleinputvalidator' => '/src/interfaces/input_validator.php'," >> autoload.php
	echo "    'ezcconsoleinvalidoptionnameexception' => '/src/exceptions/invalid_option_name.php'," >> autoload.php
	echo "    'ezcconsoleinvalidoutputtargetexception' => '/src/exceptions/invalid_output_target.php'," >> autoload.php
	echo "    'ezcconsolemenudialog' => '/src/dialog/menu_dialog.php'," >> autoload.php
	echo "    'ezcconsolemenudialogdefaultvalidator' => '/src/dialog/validators/menu_dialog_default.php'," >> autoload.php
	echo "    'ezcconsolemenudialogoptions' => '/src/options/menu_dialog.php'," >> autoload.php
	echo "    'ezcconsolemenudialogvalidator' => '/src/interfaces/menu_dialog_validator.php'," >> autoload.php
	echo "    'ezcconsolenopositionstoredexception' => '/src/exceptions/no_position_stored.php'," >> autoload.php
	echo "    'ezcconsolenovaliddialogresultexception' => '/src/exceptions/no_valid_dialog_result.php'," >> autoload.php
	echo "    'ezcconsoleoption' => '/src/input/option.php'," >> autoload.php
	echo "    'ezcconsoleoptionalreadyregisteredexception' => '/src/exceptions/option_already_registered.php'," >> autoload.php
	echo "    'ezcconsoleoptionargumentsviolationexception' => '/src/exceptions/option_arguments_violation.php'," >> autoload.php
	echo "    'ezcconsoleoptiondependencyviolationexception' => '/src/exceptions/option_dependency_violation.php'," >> autoload.php
	echo "    'ezcconsoleoptionexception' => '/src/exceptions/option.php'," >> autoload.php
	echo "    'ezcconsoleoptionexclusionviolationexception' => '/src/exceptions/option_exclusion_violation.php'," >> autoload.php
	echo "    'ezcconsoleoptionmandatoryviolationexception' => '/src/exceptions/option_mandatory_violation.php'," >> autoload.php
	echo "    'ezcconsoleoptionmissingvalueexception' => '/src/exceptions/option_missing_value.php'," >> autoload.php
	echo "    'ezcconsoleoptionnoaliasexception' => '/src/exceptions/option_no_alias.php'," >> autoload.php
	echo "    'ezcconsoleoptionnotexistsexception' => '/src/exceptions/option_not_exists.php'," >> autoload.php
	echo "    'ezcconsoleoptionrule' => '/src/structs/option_rule.php'," >> autoload.php
	echo "    'ezcconsoleoptionstringnotwellformedexception' => '/src/exceptions/option_string_not_wellformed.php'," >> autoload.php
	echo "    'ezcconsoleoptiontoomanyvaluesexception' => '/src/exceptions/option_too_many_values.php'," >> autoload.php
	echo "    'ezcconsoleoptiontypeviolationexception' => '/src/exceptions/option_type_violation.php'," >> autoload.php
	echo "    'ezcconsoleoutput' => '/src/output.php'," >> autoload.php
	echo "    'ezcconsoleoutputformat' => '/src/structs/output_format.php'," >> autoload.php
	echo "    'ezcconsoleoutputformats' => '/src/structs/output_formats.php'," >> autoload.php
	echo "    'ezcconsoleoutputoptions' => '/src/options/output.php'," >> autoload.php
	echo "    'ezcconsoleprogressbar' => '/src/progressbar.php'," >> autoload.php
	echo "    'ezcconsoleprogressbaroptions' => '/src/options/progressbar.php'," >> autoload.php
	echo "    'ezcconsoleprogressmonitor' => '/src/progressmonitor.php'," >> autoload.php
	echo "    'ezcconsoleprogressmonitoroptions' => '/src/options/progressmonitor.php'," >> autoload.php
	echo "    'ezcconsolequestiondialog' => '/src/dialog/question_dialog.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogcollectionvalidator' => '/src/dialog/validators/question_dialog_collection.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogmappingvalidator' => '/src/dialog/validators/question_dialog_mapping.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogoptions' => '/src/options/question_dialog.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogregexvalidator' => '/src/dialog/validators/question_dialog_regex.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogtypevalidator' => '/src/dialog/validators/question_dialog_type.php'," >> autoload.php
	echo "    'ezcconsolequestiondialogvalidator' => '/src/interfaces/question_dialog_validator.php'," >> autoload.php
	echo "    'ezcconsolestandardinputvalidator' => '/src/input/validators/standard.php'," >> autoload.php
	echo "    'ezcconsolestatusbar' => '/src/statusbar.php'," >> autoload.php
	echo "    'ezcconsolestatusbaroptions' => '/src/options/statusbar.php'," >> autoload.php
	echo "    'ezcconsolestringtool' => '/src/tools/string.php'," >> autoload.php
	echo "    'ezcconsoletable' => '/src/table.php'," >> autoload.php
	echo "    'ezcconsoletablecell' => '/src/table/cell.php'," >> autoload.php
	echo "    'ezcconsoletableoptions' => '/src/options/table.php'," >> autoload.php
	echo "    'ezcconsoletablerow' => '/src/table/row.php'," >> autoload.php
	echo "    'ezcconsoletoomanyargumentsexception' => '/src/exceptions/argument_too_many.php'," >> autoload.php
	echo "), __DIR__);" >> autoload.php


	VENDOR_DIR="${EPREFIX}/usr/share/php"
	cat >> autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	"${VENDOR_DIR}/Fedora/Autoloader/autoload.php",
	"${VENDOR_DIR}/Zetacomponents/Base/autoload.php"
]);
EOF
}

src_install() {
	insinto "/usr/share/php/Zetacomponents/Console-Tools"
	doins -r *.php design docs src tests
}
