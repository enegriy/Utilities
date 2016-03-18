use warnings;
use strict;
use File::Spec;
use File::Copy qw(copy);
use File::Path qw( make_path rmtree);
use Data::Dumper;
use POSIX;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use Time::Piece;

require "delete_old_backup.pm";

my $do_delete = 1;
my(	$arg1 ) = @ARGV;
if(defined($arg1) and $arg1 eq '-nodelete'){
	$do_delete = 0;
}


# Спрашиваем о намерениях
print "Do you want to make a BACKUP of the site? y - <<Yes>>, n - <<No>>"."\n";
my $answer = <STDIN>;
chomp $answer;

if($answer eq 'y')
{
	# Путь к серверу
	my $path_to_server = "\\\\192.168.15.15\\c\$";

	# Путь к каталогу с BuckUp
	my $path_to_backup = "\\\\192.168.15.15\\c\$\\BACKUP";

	# Пути к сайтам DocShell
	my @docshell_sites = ("inetpub\\auth", "inetpub\\my", "inetpub\\wwwroot\\DocShell");

	# Текущая дата
	my $current_date = POSIX::strftime( '%Y.%m.%d', ( localtime )[0..5]);

	my $new_dir_backup = File::Spec->catfile($path_to_backup, "DocShell $current_date");

	print "\n\n";
	print "Please wait while coping sites to \"$new_dir_backup\""."\n\n";

	# Копирую сайты
	foreach my $site(@docshell_sites)
	{	
		print "Coping \"$site\" ...";

		my @path_to_site = split(/\\/, $site);
		my $folder_to = $path_to_site[ $#path_to_site ];

		my $from = File::Spec->catfile($path_to_server, $site);
		my $to = File::Spec->catfile($new_dir_backup, $folder_to);
		
		if ( !-d $to ) {
			make_path $to or die "Failed to create path: $to";
		}
		
		rcopy($from, $to);
		
		print " success."."\n";
	}
	

	if($do_delete == 1){		
		#очистить историю бэкапов
		delete_old_backup( $path_to_backup );
	}
}