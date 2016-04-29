#!/usr/bin/perl
#require "BotLib2.pm";
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


binmode( STDOUT, ":utf8" );


@ARGV = map { decode(locale => $_, 1) } @ARGV;

my $search_term = "europa";  #$ARGV[0];
my $replace_term = "Europa";    #$ARGV[1];
my $summary= "Corregit: ".$search_term;
my $search = "\"".$search_term."\"";

my $outputfilename = "sentences_extracted.txt";
my $inputfilename = "list.txt";


open( my $fh,  "<:encoding(UTF-8)", $inputfilename );
open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );


#my $summary = "Normalitza ela geminada";

while(<$fh>) {
    chomp($_);
    if ($_ =~ /^(.+)$/) {
	my $title=$1;
	print "Llegint :".$title."\n";

	#if (BotLib2::article_editable($title)==0) {
        #    print "IGNORAT: ".$title."\n";
        #    next;
        #}

	my $text = $bot->get_text($title);
	my $textoriginal = $text;

#	$text =~ s/(<\/?)(R[eE][fF]|rE[fF]|reF)(>)/$1ref$3/g;
#	$text =~ s/(<\/?)(R[eE][fF]|rE[fF]|reF)( )/$1ref$3/g;
#	$text =~ s/l⋅l/l·l/g; 

	

#	if ($textoriginal =~ /(.{1,70})(\Q$search_term\E)(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})([qwertyuiopasdfghjklñçzxcvbnmàáèéìíòóùúïü\)\]\d'"] \. *([QWERTYUIOPASDFGHJKLÑÇZXCVBNMÀÁÈÉÌÍÒÓÙÚ][^QWERTYUIOPASDFGHJKLÑÇZXCVBNMÀÁÈÉÌÍÒÓÙÚ]|\n))(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})([ ,\.]\d+(µm|nm|cm|km|kg|°C|°F|°K)[ ,\.;\)\&])(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})\b(\w+[aeiouàééíìóòú](l∙l|l⋅l|l · l|l • l|l•l|l· l|l\.l|l"l|l ·l|l· l|ŀl|l\.·l|l·\.l)[aeiouàééíìóòú]\w+)\b(.{1,70})/) {
#	if ($textoriginal =~ /(.{1,70})\b([qwertyuiopasdfghjlzxcvnbm][\w·']+àn)\b(.{1,70})/) {
#        if ($textoriginal =~ /(.{0,70})\b(([LTMNSD]| [ltmnsd])[`´].*)\b(.{1,70})/){	
#	if ($textoriginal =~ /(.{1,70})\b(\w+([^Ll\]]∙l|l·[^Ll\]])\w+)\b(.{1,70})/) {

        if ($textoriginal =~ /(.{1,70})(lll)(.{1,70})/) {
	    my $abans = $1;
	    my $despres = $3;
	    $search_term=$2;


	    if ($text =~ /[\-\/\.]\Q$search_term\E[-\/ ]/) {
		print "IGNORAT: ".$title."\n";
		next;
	    }
	    if ($text =~ /\Q$search_term\E(.{0,10})\.(htm|jpg|JPG|png|PNG|svh|SVG)/) {
		print "IGNORAT PER URL O IMATGE: ".$title."\n";
		next;
	    }
	    if ($text =~ /{{literal\|.{0,3}\Q$search_term\E/) {
		print "IGNORAT PER LITERAL: ".$title."\n";
		next;
	    }

	    $replace_term=$search_term;
            $replace_term = "ll";
#	    $replace_term =~ s/\b([\w·']+)àn\b/$1an/;
#	    $replace_term =~ s/([qwertyuiopasdfghjklñçzxcvbnmàáèéìíòóùúïü\)\]\d' "]) \. *([QWERTYUIOPASDFGHJKLÑÇZXCVBNMÀÁÈÉÌÍÒÓÙÚ][^QWERTYUIOPASDFGHJKLÑÇZXCVBNMÀÁÈÉÌÍÒÓÙÚ]|\n)/$1. $2/;
#	    $replace_term =~ s/([ ,\.]\d+)((µm|nm|cm|km|kg|°C|°F|°K)[ ,\.;\)\&])/$1\&nbsp;$2/;
#	    $replace_term =~ s/\b(\w+[aeiouàééíìóòú])(l⋅l|l · l|l • l|l•l|l· l|l\.l|l"l|l ·l|l· l|ŀl|l\.·l|l·\.l)([aeiouàééíìóòú]\w+)\b/$1l·l$3/;
#            $replace_term =~ s/(.*)[`´]\s*(.*)/$1'$2/;
#	    $replace_term="MHz";
	    print $ofh "$abans$search_term$despres<|>$title<|>$search_term<|>$replace_term\n";
	    print $ofh "$abans$replace_term$despres<|>y\n\n";
	    print "EXTRET: $title\n"
	}
    }
}

close($fh);
close($ofh);
