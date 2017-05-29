#!/usr/bin/perl
use Env qw(LANGUAGE_CODE);
binmode( STDOUT, ":utf8" );
my $languageCode = $LANGUAGE_CODE;
my $regla=$ARGV[0];

open(my $sentencesexceptionsfile,  "<:encoding(UTF-8)", "$languageCode/whitelist-rules" );
my $sentencestoignore = join ("", <$sentencesexceptionsfile>);
close $sentencesexceptionsfile;

my $inputfilename = "sentences_$regla.txt";
my $outputfilename = "sentences_$regla.cleaned.txt";

open( my $fh,  "<:encoding(UTF-8)", $inputfilename );
open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );

my $ignore=0;
while (my $line = <$fh>) {
    chomp($line);
    if ($line =~ /^(.+)<\|>(.+)<\|>(.+)<\|>(.*)$/) {
$context=$1;
if ($sentencestoignore =~ /\Q$context\E/) {
    $ignore=1 
} else {
      $ignore=0
}
    }
    if (!$ignore) {
	print $ofh "$line\n";
    }
}

close ($fh);
close ($ofh);
