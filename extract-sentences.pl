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


my $search_term = $ARGV[0];
my $replace_term = $ARGV[1];
my $summary= "Corregit: ".$search_term;
my $search = "\"".$search_term."\"";

my $outputfilename = "sentences_extracted.txt"; #"regla_".$search_term.".txt";

open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );


my @pages = $bot->search($search."~0", 0);

print "**** CERCANT: ".$search_term." ****\n";

foreach (@pages) {
    chomp($_);
    if ($_ =~ /^(.+)$/	) {
	
	my $title=$1;
	
	my $text = $bot->get_text($title);
	my $textoriginal = $text;
	print "Llegint: ".$title."\n";

#	if (BotLib2::article_editable($title)==0) {
#	    print "IGNORAT: ".$title."\n";
#	    next;
#	}
	if ($text =~ /[-\/]$search_term[-\/ ]/) {
	    print "IGNORAT: ".$title."\n";
	    next;
	}


	#$text =~ s/\b$search_term\b/$replace_term/g; 
	$textoriginal =~ s/\n/ /g; 



	if ($textoriginal =~ /(.{1,70})\b\Q$search_term\E\b(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})\ba\. ?C\.(.{1,70})/) {
	    my $abans = $1;
	    my $despres = $2;

	    print $ofh "$abans$search_term$despres<|>$title<|>$search_term<|>$replace_term\n";
	    print $ofh "$abans$replace_term$despres<|>y\n\n";
	    print "EXTRET: ".$title."\n";
	}
    }
}

#close($fh);
close($ofh);
