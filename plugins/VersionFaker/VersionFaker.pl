package MT::Plugin::Util::OMV::VersionFaker;
# VersionFaker (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id: VersionFaker.pl 333 2012-11-30 08:52:42Z pirolix $

use strict;
use warnings;
use MT 4;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev: 333 $') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    # Basic descriptions
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2013/09162111/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Allow you to modify MT's VERSION, PRODUCT_NAME and so on">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",

    # Configurations
    system_config_template => "$VENDOR/$MYNAME/config.tmpl",
    settings => new MT::PluginSettings ([
        [ 'mt_version',         { Default => $MT::VERSION, scope => 'system' } ],
        [ 'mt_schema_version',  { Default => $MT::SCHEMA_VERSION, scope => 'system' } ],
        [ 'mt_product_name',    { Default => $MT::PRODUCT_NAME, scope => 'system' } ],
        [ 'mt_product_code',    { Default => $MT::PRODUCT_CODE, scope => 'system' } ],
        [ 'mt_product_version', { Default => $MT::PRODUCT_VERSION, scope => 'system' } ],
        [ 'mt_version_id',      { Default => $MT::VERSION_ID, scope => 'system' } ],
    ]),
});
MT->add_plugin ($plugin);

sub instance { $plugin; }



sub init_app {
    if (defined (my $settings = &instance->get_config_hash)) {
        no strict 'refs';
        ${"MT::$_"} = $settings->{'mt_'. lc $_}
            foreach qw/VERSION SCHEMA_VERSION PRODUCT_NAME PRODUCT_CODE PRODUCT_VERSION VERSION_ID/;
    }
}

1;