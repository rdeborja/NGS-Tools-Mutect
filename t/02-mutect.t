use Test::More tests => 2;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;

BEGIN: {
    use_ok('NGS::Tools::Mutect');
	}

my $tumour = 'tumour.bam';
my $normal = 'normal.bam';
my $reference = 'hg19.fa';
my $sample = 'sample';
my $coverage_file = join('.', $sample, 'mutect.coverage.wig');
my $output = join('.', $sample, 'mutect.output.txt');
my $dbsnp = 'dbsnp.vcf';
my $cosmic = 'cosmic.vcf';
my $mutect = NGS::Tools::Mutect->new();
my $mutect_output = $mutect->run_mutect(
	normal => $normal,
	tumour => $tumour,
	reference => $reference,
	coverage_file => $coverage_file,
	out => $output,
	dbsnp => $dbsnp,
	cosmic => $cosmic
	);
my $expected_command = '/usr/bin/java -Xmx8g -jar $MUTECTROOT/mutect.jar --analysis_type MuTect --reference_sequence hg19.fa --cosmic cosmic.vcf --dbsnp dbsnp.vcf --input_file:normal normal.bam --input_file:tumor tumour.bam --out sample.mutect.output.txt --coverage_file sample.mutect.coverage.wig';
is($mutect_output->{'cmd'}, $expected_command, 'MuTect command as expected');

SKIP: {

	}
