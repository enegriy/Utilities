use warnings;
use strict;
use File::Spec;
use Data::Dumper;
use File::stat;

require "tornado_appserver_config.pm";

my $wait_minutes = 2;
my $work_dir = "D:\\Salary\\Source";

my ($work_dir_par, $wait_minutes_par) = @ARGV;

if(defined($work_dir_par)){
	$work_dir = $work_dir_par;
}
if(defined($wait_minutes_par)){
	$wait_minutes = $wait_minutes_par;
}

my $server_dir = File::Spec->catfile($work_dir,"Server");
my $packs_dir = File::Spec->catfile($server_dir,"packs");

my $is_gen_appserver = 0;
foreach(@ARGV)
{
	if($_ eq '-mssql')
	{
		gen_appserver_mssql("Salary", $server_dir);
		$is_gen_appserver = 1;
	}
	elsif($_ eq '-postgre')
	{
		gen_appserver_postgre("Salary", "admin", "1", $server_dir);
		$is_gen_appserver = 1;
	}
}
if($is_gen_appserver == 0)
{
	gen_appserver_mssql("Salary", $server_dir);
}

print "Autodeploy waiting...\n";

my $last_modification = 0;
while($last_modification < $wait_minutes)
{
	sleep 60;

	opendir(my $dir, $packs_dir) or die "can't opendir $packs_dir: $!";
	my @files = &get_files( $dir );

	my $time_last_file = 0;
	my $file_name;
	foreach(@files)
	{
		my $time_file = stat(File::Spec->catfile($packs_dir, $_))->mtime;
		
		if($time_last_file < $time_file){
			$time_last_file = $time_file;
			$file_name = $_;
		}
	}
	$last_modification = (time - $time_last_file) / 60;
	printf ("%s => %1.1f\n",$file_name, $last_modification);
}

&run_deploy ( $server_dir );



sub get_files{
	my $rdir = shift;

	my @rslt = ();
	while (defined(my $file = readdir($rdir))) {
		next unless $file =~ /\.pkg/i;
		push @rslt, $file;	
	}
	@rslt;
}

sub run_deploy{
	my $s_dir = shift;
	print "Run deploy...\n";
	system ("start ".File::Spec->catfile($s_dir, "TornadoServer.exe")." -deploy");
}