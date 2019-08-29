#!/usr/bin/perl
use MediaWiki::Bot;
use Env qw(LANGUAGE_CODE);

my $languageCode = $LANGUAGE_CODE;

my $wiki = "$languageCode.wikipedia.org";

my $bot = MediaWiki::Bot->new({
    assert      => 'bot',
    host        => $wiki,
    operator    => 'Jaumeortola',
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
my $search = "\"".$search_term."\"";
#my $search = "\"a coves\"";

#$search = "graus Richter";
#$search_term = "graus Richter";
#$replace_term = "en l'escala de Richter";

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
	    my $before = $1;
	    my $after = $2;

	    if ($before =~/[-\/\?\&\.]$/ && $after =~ /^[\.=\-\/]/) {  #It's probably an URL
		print "IGNORED: ".$title."\n";
		next;
	    }

	    if ($sentencestoignore !~ /\Q$before$search_term$after\E/) {
		print $ofh "$before$search_term$after<|>$title<|>$search_term<|>$replace_term\n";
		print $ofh "$before$replace_term$after<|>y\n\n";
		print "EXTRACTED FROM: ".$title."\n";
	    } else {
		print "IGNORED (sentence exception): ".$title."\n";
	    }
	}
    }
}

#close($fh);
close($ofh);

