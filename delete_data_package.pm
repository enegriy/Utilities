sub delete_data_package{
	my $dir = shift;

	opendir(DIR, $dir) or die "can't opendir $dir: $!";
	
	print "Start delete data packages!\n";
	
	my $count_files_was_delete = 0;
	while (defined(my $file = readdir(DIR))) {
		if($file =~ /Data[2]?.pkg/i)
		{
			unlink($dir."\\".$file) or warn "failed on $dir\\$file: $!\n";
			print $file."\n";
			$count_files_was_delete++;
		}
	}

	print "Count was deleted: $count_files_was_delete \n";

	closedir(DIR);
}

1;