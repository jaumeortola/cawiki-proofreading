#!/usr/bin/perl
use strict;
use warnings;
#use autodie;
use utf8;

binmode( STDOUT, ":utf8" );

my $inputfilename = "dump-data/cawiki-latest-pages-articles.xml";
my $outputfilename = "list.txt";

open( my $fh,  "<:encoding(UTF-8)", $inputfilename );
open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );

my $title="";
my $ns=1;
my $found=1; 

while (my $line = <$fh>) {
    chomp($line);
    if ($line =~ /<title>(.+)<\/title>/) {
	$title = $1;
	$found=0;
    }
    if ($line =~ /<ns>(.+)<\/ns>/) {
	$ns = $1;
    }
    if ($found == 0 && $ns == 0) { 
	if ($line =~ /\b(.*lll.*)\b/) {
	    my $word= $1;
	    print $ofh "$word\n";
	    print $ofh "ARTICLE: $title\n";
	    $found=1;

	}
    }
}
#	if ($line =~ /([dDlL]'+\[\[[^\]]+\|\s+[^\]]+\]\])/) {
# 	if ($line =~ /(&lt;\/ref&gt;[\w]+)/ ) {
# 	if ($line =~ /\b([\w'’·]+(l ?∙ ?l)[\w'’·]+)\b/ ) {
#	if ($line =~ /\b(Sud-Àfrica|[Ll]a Península Ibèrica)\b/) {
#	if ($line =~ /(\b[\w'’·]+([^Ll\]]·l|l·[^Ll\]])[\w'’·]+\b)/ ) {
#	if ($line =~ /\b([\w'’·]+ll·l[\w'’·]+|[\w'’·]+l·ll[\w'’·]+)\b/ ) {
#	if ($line =~ /\b([\w'’·]+(memt|mnet|nemt|mnt))\b/ ) {
#	if ($line =~ /(\b(Nord|nord|Sud|sud) o?est)\b/ ) {
#        if ($line =~ /(\d+( |&nbsp;| )%)/ ) {
#	if ($line =~ /\b([\w'’·]+(éss[ei]n|àn|mnet|à[bv]en|àren|éren))\b/) {	

#	if ($line =~ /&lt;\/?(R[eE][fF]|rE[fF]|reF) /) {
#	if ($line =~ /l ?⋅ ?l/) {
#	if ($line =~ /\b(.+lI.+?|[Ll]I.+?|I'.+?)\b/) {
#	if ($line =~ /(EE\.UU\.)/) 
=pod
#	if ($line =~ /([ '’]europa\b)/) {
	if ($line =~ /\b([\w'’]*[aeiouàééíìóòú](l∙l|l⋅l|l · l|l • l|l•l|l· l|l\.l|l"l|l ·l|l· l|ŀl|l\.·l|l·\.l)[aeiouàééíìóòú][\w'’]*)\b/) {

	if (($line =~ /( [lmnstd][\`´]|[LMNSTD][\`´]|[\`´]s[;,  .])/) 
	|| ($line =~ /( [lmnstd]['’] \[\[|[LMNSTD]['’] \[\[)/)
	|| ($line =~ /( [lmnstd]['’] ''|[LMNSTD]['’] '')/) 
	|| ($line =~ /( [lmnstd][\`´] |[LMNSTD][\`´] )/) 
	|| ($line =~ /( [lmnstd]['’] {2,}\[\[|[LMNSTD]['’] {2,}\[\[)/) 
	|| ($line =~ /( [lmnstd]['’] {2,}''|[LMNSTD]['’] {2,}'')/)) {
=cut
#	if ($line =~ /( [;,] )/) {
#	if ($line =~ /([1234567890]+&lt;sup&gt;ena&lt;\/sup&gt;)/) {
#	if ($line =~ /([1234567890]+ena[ ,;.])/) {
#	if ($line =~ /([1234567890]+(enes|ens|èna|èns)[ ,;.])/) {
#	if ($line =~ /(&lt;!--.*Varietat dialectal:.*[Vv]alencià)/) {
#	if ($line =~ /([Mm]ort(a|s|es)?|[Dd]ocumentats?|[Dd]ocumentad(a|es)|[Ff]undats?|[Ff]undad(a|es)|[Dd]atats?|[Dd]atad(a|es)) al \d\d+/ ) {
#	if ($line =~ /((Fins|\bfins) +\d+)/) {
#	if ($line =~ /([Ee]ntre +\d+ +(fins|fins +a) +\d+)/) {
#	if ($line =~ /\b(.*[éè]ssin\b)/) {
#	if ($line =~ /(\b[eE]nlloc d['’].+?\b)/){
#	if ($line =~ /\b(\p{Word}+ò)\b/) {
#	if ($line =~ /([Ll]a \[?\[?Península [iI]bèrica)/) {
#	if ($line =~ /([Ll]a \[?\[?Península [iI]tàlica)/) {
#	if ($line =~ /( l )/) {
#	if ($line =~ /(\d +\b([aA]\. ?C|[dD]\. ?C|AC|DC|AD|BC))\b/) {
#	if ($line =~ /([\dIXCV]+ +\b([aA]\. *C|[dD]\. *C))\b/) {
#	if ($line =~ /(..º *[CKF]..)/) {
#	if ($line =~ /(\d *° [CKF]\b|\d ° *[CKF]\b)/) {
#	if ($line =~ /(\[\[[°º] *[CKF]\]\])/) {
#	if ($line =~ /([°º] *K)/) {
#	if ($line =~ /( \. *)/) {
#	if ($line =~ /( +&lt;[rR][eE][fF].{10})/) {
#	if ($line =~ /(&lt;ref .{1,50}\/+&gt;[qwertyuiopasdfghjklñzxcvbnmàáèéìíòóùúQWERTYUIOPASDFGHJKLÑZXCVBNMÀÁÈÉÌÍÒÓÙÚ\[\(]..)/) {
#	if ($line =~ /(&lt;[rR][eE][fF][^&]+\/&gt;[^&]+&lt;\/[rR][eE][fF].)/) {
#	if ($line =~ /(\d+(µm|nm|mm|cm|dm|km|Km|kg|Kg|g|°C|°F|°K)[^<\d\w])/) {
#	if ($line =~ /\b(etc[…,;:»\)\]\}<])/) {
#	if ($line =~ /\b([\w'’·]+[àa]ben)\b/) {
#	if ($line =~ /\b([\w'’·]+àven)\b/) {
#	if ($line =~ /\b([\w'’·]+àn)\b/) {
#	if ($line =~ /\b([\w'’·]+mnet)\b/) {
#	if ($line =~ /\b([\w'’·]+éssin)\b/) {
#	if ($line =~ /\b(preciss[\w]+)\b/) {
#	if ($line =~ /\b((Nord|Sud)-Amèrica)\b/) {
#	if ($line =~ /\b(\w+[aeiouàééíìóòú](l⋅l|l · l|l • l|l•l|l· l|l\.l|l"l|l ·l|l· l|ŀl|l\.·l|l·\.l)[aeiouàééíìóòú]\w+)\b/) {
#	if ($line =~ /\b(\w+ç[ei]\w*)\b/) {
#	if ($line =~ /\b(Mhz)\b/) {
#	if ($line =~ /\b([KkGg]hz|KHz)\b/) {
#	if ($line =~ /\b(\d+[KkGMmg][Hh]z)\b/) {
#	if ($line =~ /(\.(És|Van?|També|I|Van|Fou|Els?|La|Les|Aquests?|Aquesta|Aquestes|Són|Uns?|Una|Unes)[ ,])/ ) {
#	if ($line =~ /\b([\w'’·]+[éèíí]ssin)\b/) {
#	if ($line =~ /(([;.] |\()[Vv]eure \b.+?\b)/) {
#       if ($line =~ /(… *\.)/) {
