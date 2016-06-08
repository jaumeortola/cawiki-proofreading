#!/usr/bin/perl
use MediaWiki::Bot;
my $bot = MediaWiki::Bot->new({
    assert      => 'bot',
    host        => 'ca.wikipedia.org',
});

use strict;
use warnings;
use autodie;
use utf8;

use Encode::Locale;
use Encode;

@ARGV = map { decode(locale => $_, 1) } @ARGV;

binmode( STDOUT, ":utf8");


my $search_term = "otorgar"; #$ARGV[0];
my $replace_term = "";  #$ARGV[1];
my $summary= "Corregit: ".$search_term;
my $search = $search_term;

open(my $exceptionsfile,  "<:encoding(UTF-8)", "ca/excepttitle.cfg" );
my $excepttitle = join("",<$exceptionsfile>);
close $exceptionsfile;
$excepttitle =~ s/ *\n/|/g;
$excepttitle =~ s/\|$//;

my $outputfilename = "sentences_extracted.txt"; #"regla_".$search_term.".txt";
open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );


my @pages = $bot->search($search, 0);

print "**** CERCANT: ".$search_term." ****\n";

foreach (@pages) {
    chomp($_);
    if ($_ =~ /^(.+)$/	) {
	
	my $title=$1;
	
	my $text = $bot->get_text($title);
	my $textoriginal = $text;
	print "Llegint: ".$title."\n";

        if ($title =~ /$excepttitle/) {
	    print "IGNORAT: ".$title."\n";
	    next;
	}


	if ($text =~ /[-\/]$search_term[-\/ ]/) {
	    print "IGNORAT: ".$title."\n";
	    next;
	}


	#$text =~ s/\b$search_term\b/$replace_term/g; 
	$textoriginal =~ s/\n/ /g; 



	if ($textoriginal =~ /(.{1,70})\b([Oo]torg.+?)\b(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})\ba\. ?C\.(.{1,70})/) {
	    my $abans = $1;
	    my $despres = $3;
            my $original_term = $2;
	    $replace_term= $original_term;

	    print "$1 $2 $3\n";
            $replace_term =~ s/^O(.+)$/A$1/;
            $replace_term =~ s/^o(.+)$/a$1/;
	    
	    print $ofh "$abans$original_term$despres<|>$title<|>$search_term<|>$replace_term\n";
	    print $ofh "$abans$replace_term$despres<|>y\n\n";
	    print "EXTRET: ".$title."\n";
	}
    }
}

#close($fh);
close($ofh);