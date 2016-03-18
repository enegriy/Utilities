sub delete_old_backup{

	# Путь к каталогу с BuckUp
	my $path_to_backup = shift;
	#my $path_to_backup = "\\\\192.168.15.15\\c\$\\BACKUP";

	# Количество дней хранения бэкапов
	my $num_days = 120;

	# Текущая дата - дни хранения
	my $date_min = time() - ($num_days * 24 * 60 * 60);	

	opendir (DIR, $path_to_backup);
	my @dirs = readdir DIR;

	foreach $file(@dirs){
		my $path_to_file = File::Spec->catfile($path_to_backup, $file);

		my $mtime = (stat($path_to_file))[9];
		if($mtime <= $date_min)
		{
			rmtree($path_to_file);
		}
	}
}

1;


