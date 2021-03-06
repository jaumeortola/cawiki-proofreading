#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use utf8;
use Env qw(LANGUAGE_CODE);
use String::Diff;
use String::Diff qw( diff_fully diff diff_merge diff_regexp );# export functions

# change to default marks
  %String::Diff::DEFAULT_MARKS = (
      remove_open  => 'ẀdelẀ',
      remove_close => 'Ẁ/delẀ',
      append_open  => 'ẀinsẀ',
      append_close => 'Ẁ/insẀ',
      separator    => '', # for diff_merge
  );

binmode( STDOUT, ":utf8" );

my $languageCode = $LANGUAGE_CODE;

my $regla=$ARGV[0];
if (!defined $regla) {
    $regla="extracted";
}
my $ofnDiscarded="$languageCode/whitelist-extracted-sentences";
if ($regla !~ /^extracted$/) {
    $ofnDiscarded="$languageCode/whitelist-rules";
}
open(my $of_ignore,  ">>:encoding(UTF-8)", $ofnDiscarded);

open(my $exceptionsfile,  "<:encoding(UTF-8)", "$languageCode/excepttitle.cfg" );
my $excepttitle = join("",<$exceptionsfile>);
close $exceptionsfile;
$excepttitle =~ s/ *\n/|/g;
$excepttitle =~ s/\|$//;

my $inputfilename = "sentences_$regla.txt";
my $outputfilename = "bot.txt"; #"bot_$regla.txt";

open( my $fh,  "<:encoding(UTF-8)", $inputfilename );
open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );


my $inregla=0;
my $title="";
my $suggestion="";
my $context="";
my $error="";
my $correcte="";
my $accio="";
my $liniesregla=0;
my $longitud=0;
my $longitudabans=0;
my $longituddespres=0;
my $liniaRef=0;
#open( my $ofh2,  ">:encoding(UTF-8)", "regla_$regla.txt" );

while (my $line = <$fh>) {
    chomp($line);
    if ($line =~ /^(.+)<\|>(.+)<\|>(.+)<\|>(.*)$/) {
	$context=$1;
	$title=$2;
	$error=$3;
	$suggestion=$4;
#	print "$title\n";
    } elsif ($line =~ /^(.+)<\|>([ynd])$/) {
	$correcte=$1;
	$accio=$2;
#	print "$correcte\n";
        if ($title =~ /$excepttitle/) {
	    print "IGNORED: ".$title."\n";
	    next;
	}
	if ($accio =~/^y$/) {
	    &Eixida();
	}
	if ($accio =~/^d$/) {
	    print $of_ignore "$context\n";
	}

    }

}

sub Eixida {
  if ($accio eq 'y') {
    my $merged = String::Diff::diff_merge($context, $correcte);
#    print $merged;
    my $abans=""; my $despres="";
    if ($merged =~ /^([^Ẁ]+)\b.*(Ẁ.+Ẁ).*?\b([^Ẁ]+)$/) {
	$abans=$1;
	$despres=$3; #!!!!! COMPROVAR !!!!!!!!! No funciona amb <ref> o <sec>
#	if (length($abans) < $longitudabans) {
	    $longitudabans=length($abans);
#	}
#	if (length($despres) < $longituddespres) {
	    $longituddespres=length($despres);
#	}
#	print $despres;
	my $old=""; my $new="";
	if ($context =~ /(.{$longitudabans})(.+)(.{$longituddespres})/) {
	    $abans=$1;
	    $old=$2;
	    $despres=$3;
	}
	if ($correcte =~ /\Q$abans\E(.+)\Q$despres\E/) {
	    $new=$1;
	}
	$abans =~ s/^.+(.{20})$/$1/;
	$despres =~ s/^(.{20}).+$/$1/;
	print $ofh "$title<|>$abans<|>$old<|>$despres<|>$new\n";
    }
  }
}

close ($fh);
close ($ofh);
close ($of_ignore);

system("sort bot.txt -o bot.txt");
system("wc -l bot.txt");
