#!/usr/bin/perl
use strict;
use warnings;
#use autodie;
use utf8;

binmode( STDOUT, ":utf8" );

my $infilename   = "dump-data/results.txt";
my $outfilename  = "dump-data/results-summary.txt";

open( my $fh,  "<:encoding(UTF-8)", $infilename );

my $title="";
my $previoustitle="";
my $matches=0;
my %pages = ();
my %pagesByNumberOfErrors = ();
my %rules = ();

while (my $line = <$fh>) {
    chomp($line);
    if ($line =~ /^Title: (.+)$/) {
	$title=$1;

	if ($title !~ /^\Q$previoustitle\E$/) {
	    #recompte article anterior
	    if (not exists $pagesByNumberOfErrors{$matches}) {
		$pagesByNumberOfErrors{$matches}=1;
	    } else {
		$pagesByNumberOfErrors{$matches}++;
	    }
	    #article nou
	    $pages{$title}=0;
	    $matches=0;
	}

    }
    if ($line =~ / Rule ID: ([^\[]+)/) {
	my $ruleID=$1;
	if (exists $rules{$1})	{
	    $rules{$1}++;
	}
	else {
	    $rules{$1}=1;
	}
#	if ($ruleID !~ /(UNPAIRED_BRACKETS|UPPERCASE_SENTENCE_START|WORD_REPEAT_RULE|COMMA_PARENTHESIS_WHITESPACE|WHITESPACE_RULE|WORD_REPEAT_BEGINNING_RULE|ESPAI_DESPRES_DE_PUNT|CA_UNPAIRED_BRACKETS|GUIONET_SOLT|EXIGEIX_VERBS_CENTRAL|EXIGEIX_ACCENTUACIO_GENERAL|EVITA_DEMOSTRATIUS_EIXE|PUNTS_SUSPENSIUS|EXIGEIX_POSSESSIUS_V)/) {
	    $pages{$title}++;
	    $matches++;
#	}
    }
    $previoustitle=$title;
}
#recompte últim article
if (not exists $pagesByNumberOfErrors{$matches}) {
    $pagesByNumberOfErrors{$matches}=1;
} else {
    $pagesByNumberOfErrors{$matches}++;
}

close ($fh);


open( my $ofh, ">:encoding(UTF-8)", $outfilename );

print $ofh "*************************\n";
print $ofh "Rules by number of errors\n";
print $ofh "*************************\n";
foreach (sort { ($rules{$b} <=> $rules{$a}) || ($a cmp $b) } keys %rules) 
{
    print $ofh "$rules{$_} errors: $_\n";
}


print $ofh "*************************************\n";
print $ofh "Number of pages by errors per article\n";
print $ofh "*************************************\n";
foreach (sort { $b <=> $a } keys %pagesByNumberOfErrors) 
{
    print $ofh "$_ errors: $pagesByNumberOfErrors{$_} pages\n";
}

print $ofh "*******************************\n";
print $ofh "Pages sorted by numer of errors\n";
print $ofh "*******************************\n";
foreach (sort { ($pages{$b} <=> $pages{$a}) || ($a cmp $b) } keys %pages) 
{
    print $ofh "$_: $pages{$_}\n";
}

close ($ofh);


