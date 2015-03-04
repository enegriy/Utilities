use strict;
use warnings;
use File::Basename;
use File::Spec;
use File::Path;
use Archive::Zip qw( :ERROR_CODES );
use File::Copy;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);



my $install_dir = "P:\\ОР\\_Tornado\\_Emily\\15186";
my $work_dir = "D:\\Salary\\Source";
my $base_name = "Salary";



my(	$path_to_istall, $path_to_work,	$base_name_par ) = @ARGV;

if(defined($path_to_istall)){
	$install_dir = $path_to_istall;
}
if(defined($path_to_work)){
	$work_dir = $path_to_work;
}
if(defined($base_name_par)){
	$base_name = $base_name_par;
}

print "\nInstall directory: $install_dir \nWork directory: $work_dir\nSqlServer Base Name: $base_name\n\n";



my $tmp_dir = File::Spec->catfile(File::Spec->tmpdir(), 'tornado_extracted');
my @actual_dirs = qw(Client Server TornadoLib);



#Распаковка архива
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



#удаляю лишние файлы из tempdir
print "Deleting unnecessary files and directories...\n";
unlink glob "$tmp_dir\\*";
#удаляю лишние каталоги из tempdir
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



#копирую appserver.config $work_dir => $tmp_dir
print "Coping appserver.config...\n";
my $file_appserver = "appserver.config";
my $is_coped = eval{copy(
	File::Spec->catfile($work_dir, "Server", $file_appserver),
	File::Spec->catfile($tmp_dir, "Server", $file_appserver))};

unless ($is_coped) {
	print "\tGenerate appserver.config...\n";
	&gen_appserver ($base_name, File::Spec->catfile($tmp_dir, "Server"));
}



#удаление из $tmp_dir OracleDataProvider.pkg PostgreSqlDataProvider.pkg
my @files_to_del = qw(OracleDataProvider.pkg PostgreSqlDataProvider.pkg);
print "Deleting @files_to_del...\n";
foreach my $file_to_del(@files_to_del)
{
	unlink File::Spec->catfile($tmp_dir,"Server","packs",$file_to_del);
}



#Замена @actual_dirs из $tmp_dir => $work_dir
print "Coping @actual_dirs in work directories...\n";
foreach(@actual_dirs)
{
	#удаление actual_dirs из work_dir
	rmtree(File::Spec->catfile($work_dir, $_));
}
#копирование установочных файлов в рабочий каталог F:\perl\Source
rcopy($tmp_dir, $work_dir);


#запуск deploy
print "Run deploy...\n";
system ("start ".File::Spec->catfile($work_dir, "Server", "TornadoServer.exe")." -deploy");


#запуск ParusVSPackage2
my $prog_name = "ParusVSPackage2.msi";
print "Install $prog_name...\n";
system File::Spec->catfile($install_dir, $prog_name);


#удаление $tmp_dir
print "Deleting temporary files...\n";
rmtree($tmp_dir);



#генерирую appserver.config
sub gen_appserver{
	my $base_name = "BASE_NAME";
	if(defined($_[0])){
		$base_name = $_[0];
	}

	my $file = "appserver.config";
	my $dir = ".";
	if(defined($_[1])){
		$dir = $_[1];
	}

	open(FILE, "> ".File::Spec->catfile($dir, $file));

	print FILE '<?xml version="1.0" encoding="windows-1251"?>
<server-config xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<database>
		<provider>MSSQL</provider>
		<work-db-connection-string>Data Source=(local)\SQLEXPRESS;Initial Catalog='.$base_name.';Integrated Security=True;Connect Timeout=1800</work-db-connection-string>
	</database>

	<server-mode>Native</server-mode>

	<logging>
		<loggers>
			<logger type="Parus.Net.Logger.StandardStores.ConsoleLogStore, AppServer.Common">
				<filter-level>Normal</filter-level>
			</logger>
			<logger type="Parus.Net.Logger.StandardStores.TextFileLogStore, AppServer.Common">
				<filter-level>Minimal</filter-level>
				<params>
					<item key="path" value=".\Tornado_Log\" />
					<item key="period" value="daily" />
					<item key="size" value="1000000" />
				</params>
			</logger>
		</loggers>
	</logging>
	<security-config>
		<role-groups>
			<role-group role="User" group-name="Пользователи"/>
			<role-group role="ServerAdministrator" group-name="Администраторы"/>
			<role-group role="ServerAdministrator" group-name="Administrators"/>
		</role-groups>
	</security-config>

	<update-service>
		<port>9291</port>
	</update-service>
	<client-update-service>
		<port>9292</port>
	</client-update-service>
	<storage>
		<path>C:\ProgramData\Parus.TornadoServer.PerformanceBefore</path>
	</storage>
</server-config>';
	close FILE;
}