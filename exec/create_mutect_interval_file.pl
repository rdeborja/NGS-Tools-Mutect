### create_mutect_interval_file.pl ################################################################
# Create a set of target files used with MuTect.  The input takes a multi FASTA file and outputs a
# single entry per contig (chromosome).  This will appear as chrN:start-end.

### HISTORY #######################################################################################
# Version               Date                Coder           Comments
# 0.01                  2014-02-07          rdeborja        Initial code development.

### INCLUDES ######################################################################################
use warnings;
use strict;
use Carp;
use Getopt::Long;
use Pod::Usage;
use Bio::DB::Fasta;
use Bio::SeqIO;
use autodie;

### COMMAND LINE DEFAULT ARGUMENTS ################################################################
# list of arguments and default values go here as hash key/value pairs
our %opts = (
	fasta => undef
	);

### MAIN CALLER ###################################################################################
my $result = main();
exit($result);

### FUNCTIONS #####################################################################################

### main ##########################################################################################
# Description:
#	Main subroutine for program
# Input Variables:
#	%opts = command line arguments
# Output Variables:
#	N/A

sub main {
	# get the command line arguments
	GetOptions(
		\%opts,
		"help|?",
		"man",
		"fasta|f=s"
		) or pod2usage(64);
	
	pod2usage(1) if $opts{'help'};

	pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

	while(my ($arg, $value) = each(%opts)) {
		if (!defined $value) {
			print "ERROR: Missing argument $arg\n";
			pod2usage(128);
			}
		}

	my $ref_fasta = Bio::SeqIO->new(
		-file => $opts{'fasta'},
		-format => 'Fasta'
		);

	while(my $seq = $ref_fasta->next_seq()) {
		my $output_file = join('.',
			$seq->id,
			"interval"
			);
		open(my $ofh, '>', $output_file);
		print {$ofh} $seq->id, ":1-", $seq->length, "\n";
		close($ofh);
		}

	return 0;
	}


__END__


=head1 NAME

get_chr_from_fasta.pl

=head1 SYNOPSIS

B<get_chr_from_fasta.pl> [options] [file ...]

	Options:
	--help          brief help message
	--man           full documentation
	--fasta         FASTA file to process

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=back

=head1 DESCRIPTION

B<get_chr_from_fasta.pl> Create a set of target files used with MuTect.  This will appear as chrN:start-end.

=head1 EXAMPLE

get_chr_from_fasta.pl --fasta file.fa

=head1 AUTHOR

Richard de Borja -- The Hospital for Sick Children

=head1 SEE ALSO

=cut


