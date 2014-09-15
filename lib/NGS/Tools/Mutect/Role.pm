package NGS::Tools::Mutect::Role;
use Moose::Role;
use MooseX::Params::Validate;

use strict;
use warnings FATAL => 'all';
use namespace::autoclean;
use autodie;
use Env qw(TMPDIR PWD);
use File::Basename;

=head1 NAME

NGS::Tools::Mutect::Role

=cut

=head1 SYNOPSIS

Perl Moose Role wrapper for the Mutect somatic mutations caller from the Broad.

=head1 ATTRIBUTES AND DELEGATES

=head1 SUBROUTINES/METHODS

=head2 $obj->run_mutect()

Run the Mutect somatic caller.

=head3 Arguments:

=over 2

=item * mutect: Mutect JAR file to run.

=item * normal: Normal BAM file.

=item * tumour: Tumour BAM file.

=item * reference: Reference genome in FASTA format.

=item * cosmic: COSMIC VCF file.

=item * dbsnp: DBSNP VCF file.

=item * out: Name of call_stats output file.

=item * coverage_file: Coverage output file.

=item * memory: Amount of heap space allocation (default: 8)

=item * intervals: Interval file to use, should containing chr:start-end

=item * java: Java program to use (default: /usr/bin/java).

=item * tmp: Temp directory to use (default: $TMPDIR).

=item * cwd: 

=back

=cut

sub run_mutect {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		mutect => {
			isa			=> 'Str',
			required	=> 0,
			default		=> '$MUTECTROOT/mutect.jar'
			},
		normal => {
			isa         => 'Str',
			required    => 0,
			default		=> ''
			},
		tumour => {
			isa			=> 'Str',
			required	=> 1
			},
		reference => {
			isa			=> 'Str',
			required	=> 1
			},
		cosmic => {
			isa			=> 'Str',
			required	=> 1
			},
		dbsnp => {
			isa			=> 'Str',
			required	=> 1
			},
		out => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		coverage_file => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		memory => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 8
			},
		intervals => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		java => {
			isa			=> 'Str',
			required	=> 0,
			default		=> '/usr/bin/java'
			},
		tmp => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			}
		);

	# setup the temp directory


	# add the units for the memory requirements for the max heap (i.e. -Xmx parameter)
	my $memory = join('',
		$args{'memory'},
		'g'
		);

	# setup the Java engine
	my $java = join(' ',
		$args{'java'},
		"-Xmx$memory",
		);
    # create a tmpdir and use it in the java command
    if ($args{'tmp'} ne '') {
        if (! -d $args{'tmp'}) {
            make_path($args{'tmp'});
            }
        $java = join(' ',
            $java,
            '-Djava.io.tmpdir=' . $args{'tmp'}
            );
        }
    $java = join(' ',
        $java,
        '-jar',
        $args{'mutect'}
        );

	my $program = '--analysis_type MuTect';
	my $options = join(' ',
		'--reference_sequence', $args{'reference'},
		'--cosmic', $args{'cosmic'},
		'--dbsnp', $args{'dbsnp'},
		'--input_file:tumor', $args{'tumour'},
		'--out', $args{'out'},
		'--coverage_file', $args{'coverage_file'} 
		);

	# muTect can also be run in tumour only mode although this is highly
	# not recommended
	if ('' ne $args{'normal'}) {
		$options = join(' ',
			$options,
			'--input_file:normal', $args{'normal'}
			);
		}

	# setup the intervals, default to the size of the genome 
	if ($args{'intervals'} ne '') {
		$options = join(' ',
			$options,
			'--intervals', $args{'intervals'}
			);
		}

	my $cmd = join(' ',
		$java,
		$program,
		$options
		);

	my %return_values = (
		cmd => $cmd,
		output => $args{'out'},
		coverage => $args{'coverage_file'}
		);

	return(\%return_values);
	}

=head2 $obj->run_single_sample_mutect()

Run the MuTect SNV caller in single sample mode.

=head3 Arguments:

=over 2

=item * bam: BAM file to process

=back

=cut

sub run_single_sample_mutect {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		bam => {
			isa         => 'Str',
			required    => 1
			},
		output => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		reference => {
			isa			=> 'Str',
			required	=> 1
			},
		cosmic => {
			isa			=> 'Str',
			required	=> 1
			},
		dbsnp => {
			isa			=> 'Str',
			required	=> 1
			},
		out => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		coverage_file => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		memory => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 8
			},
		intervals => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		java => {
			isa			=> 'Str',
			required	=> 0,
			default		=> '/usr/bin/java'
			},
		tmp => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		mutect => {
			isa			=> 'Str',
			required	=> 0,
			default		=> '$MUTECTROOT/mutect.jar'
			}
		);

	my $output;
	if ($args{'output'} eq '') {

		}

	my %return_values = (
		cmd => $cmd,
		output => $output
		);

	return(\%return_values);
	}

=head2 $obj->create_config()

Create the configuration file containing the meta data for the Mutect run.

=head3 Arguments:

=over 2

=item * arg: argument

=back

=cut

sub create_config {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		arg => {
			isa         => 'Str',
			required    => 0,
			default     => ''
			}
		);

	my %return_values = (

		);

	return(\%return_values);
	}

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at oicr.on.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-test at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=test-test>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::Mutect::Role

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=test-test>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/test-test>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/test-test>

=item * Search CPAN

L<http://search.cpan.org/dist/test-test/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

no Moose::Role;

1; # End of NGS::Tools::Mutect::Role
