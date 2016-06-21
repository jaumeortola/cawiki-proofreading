#!/usr/bin/perl
use MediaWiki::Bot;

open(my $languageCodeFile,  "<:encoding(UTF-8)", "language-code.cfg" );
my $languageCode = <$languageCodeFile>;
close $languageCodeFile;

my $wiki = "$languageCode.wikipedia.org";

my $bot = MediaWiki::Bot->new({
    assert      => 'bot',
    host        => $wiki,
});

use strict;
use warnings;
use autodie;
use utf8;

use Encode::Locale;
use Encode;

@ARGV = map { decode(locale => $_, 1) } @ARGV;

binmode(STDOUT, ":utf8");


my $search_term = $ARGV[0];
my $replace_term = $ARGV[1];
my $summary= "Corregit: ".$search_term;
my $search = "\"".$search_term."\"";

open(my $exceptionsfile,  "<:encoding(UTF-8)", "$languageCode/excepttitle.cfg" );
my $excepttitle = join("",<$exceptionsfile>);
close $exceptionsfile;
$excepttitle =~ s/ *\n/|/g;
$excepttitle =~ s/\|$//;

open(my $sentencesexceptionsfile,  "<:encoding(UTF-8)", "$languageCode/whitelist-extracted-sentences" );
my $sentencestoignore = join ("", <$sentencesexceptionsfile>);
close $sentencesexceptionsfile;


my $outputfilename = "sentences_extracted.txt";
open( my $ofh,  ">>:encoding(UTF-8)", $outputfilename );


my @pages = $bot->search($search."~0", 0);

print "**** SEARCHING: ".$search_term." ****\n";

foreach (@pages) {
    chomp($_);
    if ($_ =~ /^(.+)$/	) {
	
	my $title=$1;
	
	my $text = $bot->get_text($title);
	my $textoriginal = $text;
	print "Reading: ".$title."\n";

        if ($excepttitle =~ /../ && $title =~ /$excepttitle/) {
	    print "IGNORED: ".$title."\n";
	    next;
	}


	#if ($text =~ /[-\/]$search_term[-\/ ]/) {
	#    print "IGNORAT: ".$title."\n";
	#    next;
	#}


	#$text =~ s/\b$search_term\b/$replace_term/g; 
	$textoriginal =~ s/\n/ /g; 



	if ($textoriginal =~ /(.{1,70})\b\Q$search_term\E\b(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})\ba\. ?C\.(.{1,70})/) {
	    my $abans = $1;
	    my $despres = $2;

	    if ($sentencestoignore !~ /\Q$abans$search_term$despres\E/) {
		print $ofh "$abans$search_term$despres<|>$title<|>$search_term<|>$replace_term\n";
		print $ofh "$abans$replace_term$despres<|>y\n\n";
		print "EXTRACTED FROM: ".$title."\n";
	    } else {
		print "IGNORED (sentence exception): ".$title."\n";
	    }
	}
    }
}

#close($fh);
close($ofh);

