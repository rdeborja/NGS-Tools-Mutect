use Test::More tests => 2;
use Test::Exception;
use Test::Moose;
use MooseX::ClassCompositor;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use BoutrosLab::Utilities::General;
use Data::Dumper;
use Env qw(TMPDIR);
use File::Temp qw(tempdir tempfile);

my $test_class_factory = MooseX::ClassCompositor->new(
	{ class_basename => 'Test' }
	);
my $mutect_test_class = $test_class_factory->class_for('NGS::Tools::Mutect::Role');

my $tumour = 'tumour.bam';
my $normal = 'normal.bam';
my $reference = 'hg19.fa';
my $sample = 'sample';
my $cosmic = 'cosmic.vcf';
my $dbsnp = 'dbsnp.vcf';

my $coverage_file = join('.', $sample, 'mutect.coverage.wig');
my $output = join('.', $sample, 'mutect.output.txt');

lives_ok {
	$mutect = $mutect_test_class->new()
	}
	'Mutect class instantiated ok';

my $mutect_run = $mutect->run_mutect(
	normal => $normal,
	tumour => $tumour,
	reference => $reference,
	coverage_file => $coverage_file,
	out => $output,
	dbsnp => $dbsnp,
	cosmic => $cosmic
	);

my $expected_cmd = '/usr/bin/java -Xmx8g -jar $MUTECTROOT/mutect.jar --analysis_type MuTect --reference_sequence hg19.fa --cosmic cosmic.vcf --dbsnp dbsnp.vcf --input_file:normal normal.bam --input_file:tumor tumour.bam --out sample.mutect.output.txt --coverage_file sample.mutect.coverage.wig';

is($mutect_run->{'cmd'}, $expected_cmd, 'MuTect command as expected');