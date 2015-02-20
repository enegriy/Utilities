#!/user/bin/perl

# Скрипт заменяет все guid(кроме 00000000-0000-0000-000000000000) в .unit, 
# это необходимо при копировании .unit в системе tornado 
# Автор: Enegriy

print "Input file name:";
$file_name 		= <STDIN>;

print "Output file name:";
$file_name_out 	= <STDIN>;

open FILE,"< $file_name"	;
open TMP ,"> $file_name_out";

while(<FILE>)
{
	if(/[0]{8}\-[0]{4}\-[0]{4}\-[0]{4}\-[0]{12}/)
	{
		print TMP $_;
		next;
	}
	elsif(/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/)
	{
		my $new_guid = `uuidgen.exe`;
		chomp $new_guid;
		s/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/$new_guid/;
		
	}
	print TMP $_;
}

close FILE;
close TMP;
