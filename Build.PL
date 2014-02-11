use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NGS::Tools::Mutect',
    license             => 'artistic_2',
    dist_author         => q{Richard de Borja <richard.deborja@sickkids.ca>},
    dist_version_from   => 'lib/NGS/Tools/Mutect.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
				'Moose'											=> 2.0,
				'Moose::Role'								=> 2.0,
				'MooseX::Params::Validate'	=> 0
    },
    add_to_cleanup     => [ 'NGS-Tools-Mutect-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
