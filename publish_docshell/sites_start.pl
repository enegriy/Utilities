use warnings;
use strict;
use File::Spec;

# Спрашиваем о намерениях
print "Do you want START docshell site? y - <<Yes>>, n - <<No>>"."\n";
my $answer = <STDIN>;
chomp $answer;

if($answer eq 'y')
{
	# Путь к серверу
	my $path_to_server = "\\\\192.168.15.15\\c\$";

	# Имя файла
	my $file_name = "App_offline.htm";

	# Пути к сайтам DocShell
	my @docshell_sites = ("inetpub\\auth", "inetpub\\my", "inetpub\\wwwroot\\DocShell");

	# Запуская сайты
	foreach my $site(@docshell_sites)
	{	
		unlink(File::Spec->catfile($path_to_server, $site, $file_name));
		print "Started \"$site\" was success"."\n";
	}
}