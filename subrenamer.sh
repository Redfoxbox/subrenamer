#!/usr/bin/perl
use strict;
use File::Basename;

my ($extension) = "";

if (scalar @ARGV == 0){
	print "Missing extension parameter. Using default file extension - mkv \n";
	$extension = "mkv";
}else{
	($extension) = @ARGV;
}


my $seasonepisodereg = qr/\d{1,2}x\d{1,2}/mp;
my $seasonreg = qr/[Ss]\d{1,2}/mp;
my $episodereg = qr/[EP|Ee]\d{1,2}/mp;
my $number = qr/\d{1,2}/mp;
my $season = "";
my $episode = "";
my $sub_season = "";
my $sub_episode = "";
my $seasonepisode = "";

my @files = <*.$extension>;
my @subs = <*.srt>;
if (scalar @files == 0){
  die "<$extension> Files not found\n";
}

foreach my $file (@files) {

    if ( $file =~ /$seasonreg/g ) {
	$season=${^MATCH};
		if ( $season =~ /$number/g ) {
		$season=${^MATCH};
		}
	}
	if ( $file =~ /$episodereg/g ) {
	$episode=${^MATCH};
		if ( $episode =~ /$number/g ) {
		$episode=${^MATCH};
		}
	}

	print "FILE: $file ---- $season $episode \n\n";
 
    foreach my $sub (@subs) {
		print "$sub\n";
	    if ( $sub =~ /$seasonreg/g ) {
		$sub_season=${^MATCH};
			if ( $sub_season =~ /$number/g ) {
			$sub_season=${^MATCH};
			}
		}else{
			if ( $sub =~ /$seasonepisodereg/g ) {
					$seasonepisode=${^MATCH};
					$seasonepisode=~ s/\D//g;
					$seasonepisode="0$seasonepisode";
			}
		}
		print "SUB: $sub ---- $sub_season $sub_episode \n\n";
		if ( $sub =~ /$episodereg/g ) {
		$sub_episode=${^MATCH};
			if ( $sub_episode =~ /$number/g ) {
			$sub_episode=${^MATCH};
			}
		}
		
		if(lc("$season$episode") eq lc("$sub_season$sub_episode")||lc("$season$episode") eq lc("$seasonepisode") ){
		print "I found subtitle file for $file.mkv, rename $sub TO $file.srt  \n";
		my $basename = basename($file,".$extension");
		rename $sub,"$basename.srt";
		}
	
	}
}





