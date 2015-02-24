my $dir = $ARGV[0];

opendir(DIR, $dir) or die "can't opendir $dir: $!";

$count_files_was_delete = 0;
while (defined(my $file = readdir(DIR))) {
	if($file =~ /Data[2]?.pkg/i)
	{
		unlink($dir."\\".$file) or warn "failed on $dir\\$file: $!\n";
		print $file."\n";
		$count_files_was_delete++;
	}
}

print "Delete count Files: $count_files_was_delete";

closedir(DIR);