use strict;
use warnings;
use File::Basename;
use File::Spec;
use File::Path;
use Archive::Zip qw( :ERROR_CODES );
use File::Copy;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use IO::Dir;

require "tornado_appserver_config.pm";

my $install_dir = "P:\\��\\_Tornado\\_Emily\\";
my $work_dir = "D:\\Salary\\Source";
my $base_name = "Salary";



my(	$install_dir_par, $work_dir_par, $base_name_par ) = @ARGV;

if(defined($install_dir_par)){
	$install_dir = $install_dir_par;
}
if(defined($work_dir_par)){
	$work_dir = $work_dir_par;
}
if(defined($base_name_par)){
	$base_name = $base_name_par;
}

&show_install_dirs( $install_dir, 3 );
print "What distribution to install: ";
chomp(my $distr = <STDIN>);
$distr = &get_actual_distrib($install_dir, $distr);
$install_dir = File::Spec->catfile($install_dir, $distr);


print "\nInstall directory: $install_dir \nWork directory: $work_dir\nSqlServer Base Name: $base_name\n\n";


print "Close application, please:\n - SmartClient\n - AssemblyDeployer\n - TornadoServer\n - Visual Studio\nPress Enter to continue...\n\n";
<STDIN>;


my $tmp_dir = File::Spec->catfile(File::Spec->tmpdir(), 'tornado_extracted');
my @actual_dirs = qw(Client Server TornadoLib);



#���������� ������
print "Unpacking archive...\n";
my $zip = Archive::Zip->new();
unless ( $zip->read( File::Spec->catfile($install_dir, "DEVELOP.zip") ) == AZ_OK ) {
      die "whoops!";
  }

my @members = $zip->members();
foreach my $element(@members)
{
  $element->extractToFileNamed(File::Spec->catfile($tmp_dir, $element->fileName()));
}



#������ ������ ����� �� tempdir
print "Deleting unnecessary files and directories...\n";
unlink glob "$tmp_dir\\*";
#������ ������ �������� �� tempdir
opendir my($dtemp), $tmp_dir or die "Couldn't open dir '$tmp_dir': $!";
my @all_dirs_in_temp = readdir $dtemp;
foreach my $dir_in_temp(@all_dirs_in_temp)
{
	my $pattern = "\\b(". join ("|", @actual_dirs).")\\b|^\\.";
	$_ = $dir_in_temp;
	unless(/$pattern/)
	{
		rmtree(File::Spec->catfile($tmp_dir, $_));
	}

}
closedir $dtemp;



#������� appserver.config $work_dir => $tmp_dir
print "Coping appserver.config...\n";
my $file_appserver = "appserver.config";
my $is_coped = eval{copy(
	File::Spec->catfile($work_dir, "Server", $file_appserver),
	File::Spec->catfile($tmp_dir, "Server", $file_appserver))};

unless ($is_coped) {
	print "\tGenerate appserver.config...\n";
	&gen_appserver ($base_name, File::Spec->catfile($tmp_dir, "Server"));
}



#�������� �� $tmp_dir OracleDataProvider.pkg PostgreSqlDataProvider.pkg
my @files_to_del = qw(OracleDataProvider.pkg PostgreSqlDataProvider.pkg);
print "Deleting @files_to_del...\n";
foreach my $file_to_del(@files_to_del)
{
	unlink File::Spec->catfile($tmp_dir,"Server","packs",$file_to_del);
}



#������ @actual_dirs �� $tmp_dir => $work_dir
print "Coping @actual_dirs in work directories...\n";
foreach(@actual_dirs)
{
	#�������� actual_dirs �� work_dir
	rmtree(File::Spec->catfile($work_dir, $_));
}
#����������� ������������ ������ � ������� ������� F:\perl\Source
rcopy($tmp_dir, $work_dir);


#������ deploy
print "Run deploy...\n";
system ("start ".File::Spec->catfile($work_dir, "Server", "TornadoServer.exe")." -deploy");


#������ ParusVSPackage2
my $prog_name = "ParusVSPackage2.msi";
print "Install $prog_name...\n";
system File::Spec->catfile($install_dir, $prog_name);


#�������� $tmp_dir
print "Deleting temporary files...\n";
rmtree($tmp_dir);



#��������� ������ ��������� ��� ���������
sub show_install_dirs{
	my $dir = "\\.";
	if(defined($_[0])){
		$dir = $_[0];
	}

	my $count = 3;
	if(defined($_[1])){
		$count = $_[1];
	}

	opendir my($dinstall), $dir or die "Couldn't open dir : $!";
	my @all_dirs_install = readdir $dinstall;
	close $dinstall;

	my %file_and_date = map {
		unless($_ =~ /^\./){
			my @attrib_dir = stat( File::Spec->catfile($dir,$_) );
			$_ => $attrib_dir[9];
		}
	} @all_dirs_install;


	
	my $cur = 0;
	foreach my $name (sort { $file_and_date{$b} <=> $file_and_date{$a} } keys %file_and_date) {
		if($cur >= $count){
			next;
		}
		$cur++;
	
		print "$name \n";
	}
}

sub get_actual_distrib{
	my $install_dir = shift;
	my $distr = shift;
	
	my $dir = IO::Dir->new( File::Spec->catfile($install_dir, $distr) );
	unless(defined($dir))
	{
		$dir = IO::Dir->new($install_dir);
		while(defined(my $f = $dir->read))
		{
			if($f =~ /$distr/i)
			{
				$distr = $f;
				print "Distribution directory: $distr \n";
				last;
			}
		}
	}
	
	$distr;
}