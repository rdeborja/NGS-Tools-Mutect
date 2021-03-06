use Test::More tests => 3;
use Test::Exception;
use Test::Moose;
use MooseX::ClassCompositor;
use FindBin qw($Bin);
use lib "$Bin/../lib";
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

# unmatched mode
my $mutect_run = $mutect->run_mutect(
	tumour => $tumour,
	reference => $reference,
	coverage_file => $coverage_file,
	out => $output,
	dbsnp => $dbsnp,
	cosmic => $cosmic,
	tmp => '/tmp'
	);
my $expected_cmd = join(' ',
	'/usr/bin/java -Xmx8g',
	'-Djava.io.tmpdir=/tmp',
	'-jar $MUTECTROOT/mutect.jar',
	'--analysis_type MuTect',
	'--reference_sequence hg19.fa',
	'--cosmic cosmic.vcf',
	'--dbsnp dbsnp.vcf',
	'--input_file:tumor tumour.bam',
	'--out sample.mutect.output.txt',
	'--coverage_file sample.mutect.coverage.wig'
	);
is($mutect_run->{'cmd'}, $expected_cmd, 'MuTect unmatched command as expected');

$mutect_run = $mutect->run_mutect(
	normal => $normal,
	tumour => $tumour,
	reference => $reference,
	coverage_file => $coverage_file,
	out => $output,
	dbsnp => $dbsnp,
	cosmic => $cosmic,
	tmp => '/tmp'
	);
$expected_cmd = join(' ',
	'/usr/bin/java -Xmx8g',
	'-Djava.io.tmpdir=/tmp',
	'-jar $MUTECTROOT/mutect.jar',
	'--analysis_type MuTect',
	'--reference_sequence hg19.fa',
	'--cosmic cosmic.vcf',
	'--dbsnp dbsnp.vcf',
	'--input_file:tumor tumour.bam',
	'--out sample.mutect.output.txt',
	'--coverage_file sample.mutect.coverage.wig',
	'--input_file:normal normal.bam'
	);
is($mutect_run->{'cmd'}, $expected_cmd, 'MuTect command as expected');
