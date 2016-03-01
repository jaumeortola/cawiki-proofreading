#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use utf8;

use POSIX qw(locale_h);
setlocale(LC_ALL, "C");

binmode( STDOUT, ":utf8" );

my $inputfilename = "dump-data/results.txt";
#my $outputfilename = "bot.txt";

open( my $fh,  "<:encoding(UTF-8)", $inputfilename );
#open( my $ofh,  ">:encoding(UTF-8)", $outputfilename );
my $regla=$ARGV[0];
my $inregla=0;
my $title="";
my $suggestion="";
my $original="";
my $context="";
my $liniesregla=0;
my $longitud=0;
my $longitudabans=0;
my $passatoriginal=0;
my $passatsuggestion=0;
my $linecount=0;

my %clauordenacio= ();
my @original;
my @corregit;
my @accio;
my @titol;
my @errors;
my @suggeriments;

my $n=-1;

open(my $exceptionsfile,  "<:encoding(UTF-8)", "ca/excepttitle.cfg" );
my $excepttitle = <$exceptionsfile>; 
close $exceptionsfile;

if (!defined $regla) {
    $regla="MYRULES";
}

open( my $ofh2,  ">:encoding(UTF-8)", "sentences_$regla.txt" );

while (my $line = <$fh>) {
    chomp($line);
    if ($line =~ /Rule ID: /) {
	if ($line =~ /Rule ID: \Q$regla\E(\[\d+\])?$/) {
#	if ($line =~ /Rule ID: $regla\[[5]\]$/) {

#	if ($line =~ /Rule ID: (A_DIT_HA_DIT|CLOACA|ET_VAU|GRAU_GREU|PER_A_QUE|STATU_QUO|TEMPLAT|UN_MES|VESAR|ACERA|COMA_A|CONCORDANCES_TOT|ESCARBAT|LLINDA_AMB|PEL_CONTRARI|TASSA_TAXA|AMB_QUE|CAMERA_CAMBRA|CONSEQUENT_CONSEGUENT|EN_BROMA|ESTORAR|GRACIES_A|JAJAJA|RESOLVENT_RESOLENT|CALS|CRIDADA|CUINA_A_GAS|DOBLAR_DOBLEGAR|ELA_EL_LA|TAMANY|TITELLA|US_VAS|CEGO|CORSET|DONANT_T_HI|LACRA|QUEDAT_QUEDA|RESITUAR|SOBAT|ARRASTRAR|COQUETO|DISCIPLINAR|DOLAR|FALLAR|FARRAGOS|GENERALITAT|MATERIA_PRIMA|MILER_MILERS|TROMPO|ALMENYS|AL_TEMPS_QUE|BARCA_MAJUSCULES|CONSTAR_COSTAR|DESVETLLAR|DEURE|FA_VA|MASSES|MOTS_SENSE_GUIONETS|OBRAR_OBRIR|OCASIONES|PARTIT_PARTIR|RABET|XULO|ARXIU_ARXIVAMENT|CELEBRAR_CONTRACTE|CONCORDANCES_QUAL|CORESPONSABLE|ESTANT_ESTAN_FENT|GERUNDI_PERD_T|MADRINA|NO_REPETIT|AL_ROIG_VIU|COMTAT|DESCONTENT|DEUS|EL_MES_AVIAT_POSSIBLE|EMPORTAR_SE_PER_DAVANT|FLUIDA|MANER|MA_ABREVIATURA|MEDICAMENT|MES_VAL|MITJAN_EL|SUMA_SUMMA|ANT_ANY|BRONCA|BUSCA|DIFOS_DIFUS|ESPESA_ESPESSA|HELENA|HOSTATGE_OSTATGE|PEL_TERRA|SISPLAU|TENIR_QUE)(\[\d+\])?$/) {

	    #print $ofh2 "Title: $title\n";
	    $inregla=1;
	} else {
	    #&Eixida();
	    $inregla=0;
	    $liniesregla=0;
	}
    }

    if ($inregla && $title !~ /$excepttitle/) {
	$liniesregla++;
	#print $ofh2 "$line\n";

#	if ($passatsuggestion) {  #No és fix!!!¡
#	    $context=$line;
#	}

	if ($line =~ /^Suggestion: ([^;]+)/) {
#	if ($line =~ /^Suggestion: (.+)$/) {
	    $suggestion=$1;
	    #$suggestion="'";
	    $passatsuggestion=1;
	} else {
	    $passatsuggestion=0;
	}

	if ($passatoriginal) {  #No és fix!!!¡
	    $linecount=$linecount+1;
	}

	if ($linecount == 3) {
	    $context=$line;
	}
	if ($linecount == 4) {
	    $passatoriginal=0;
	    $longitud=length($original);
	    &Eixida();
	    $inregla=0;
	    $liniesregla=0;
            $linecount=0;
            $original="";
	    $suggestion="";
	}

	if ($line =~ /^Error: (.+)$/) {
	    $original=$1;
	    #$suggestion="'";
	    $passatoriginal=1;
            $linecount=0;
	}

#	if ($line =~ /^(\s*)([\^]+)/) {
#	    $longitud = length($2);
#	    $longitudabans = length($1);
#	    $original = $context;
#	    $original =~ s/^.{$longitudabans}(.{$longitud}).*$/$1/;

#	    $longitud=length($original);

#	    &Eixida();
#	    $inregla=0;
#	    $liniesregla=0;
#	    $suggestion="";
#	}
#        print "$liniesregla $line\n";
#	print "$linecount $title $context $original $suggestion\n";

    }
    if ($line =~ /^Title: (.+)$/) {
	$title=qq($1);
    }
    if ($line =~ /Checking article/) {
	#&Eixida();
	$inregla=0;
	$liniesregla=0;
    }
}



sub Eixida {
    if ($inregla) {
	my $substituit=0;

	if ($suggestion =~ /^Aquesta$/) {
	    $suggestion = "Està";
	}
	if ($suggestion =~ /^aquesta$/) {
	    $suggestion = "està";
	}

	## Prepara "formulari"
	if ($suggestion =~ /^$/) {
	    $suggestion = $original;
	}
	#if ($context =~ /^(.*)$original(.*)$/) {

	if ($original =~ /^\p{Lu}.*$/) {
	    $suggestion = ucfirst $suggestion;
	}
	my $l1=$longitudabans-5;
	my $l2=$longitudabans+5;
	$n=$n+1; #compta nova entrada
	push (@original, $context);
	push (@titol, $title);
	push (@errors, $original);
	push (@suggeriments, $suggestion);
        #if ($context =~ /^(.{$l1,$l2})\b$original\b(.*)$/) {
	#if ($context =~ /^(.{$l1,$l2})\b$original(.*)$/) {
	if ($context =~ /^(.*)\b\Q$original\E\b(.*)$/ ) {
	#if ($context =~ /^(.*)$original(.*)$/) {

	    my $abans=$1;
	    my $despres=$2;
	    my $frasecorregida = "$abans$suggestion$despres";

	    #my $motprevi=$abans;
	    #$motprevi =~ s/^.*\b([^\b].+)$/$1/;
	    #$clauordenacio{$n}="$motprevi$suggestion$despres";

	    $clauordenacio{$n}="$suggestion$despres";
	    push (@corregit, $frasecorregida);
	    push (@accio, "s");
	    $substituit=1;
	} 
=pod
	else {

	    # Intenta fer la substitució de les apostrofacions
	    if ($suggestion =~ /^([ldLD]['])(.+)$/) {
		my $sugg1=$1; my $sugg2=$2;
		$original =~ /(el|El|la|La|de|De) (.+)/;
		my $orig1=$1; my $orig2=$2;
		#print "$orig1 $orig2 $sugg1 $sugg2\n";
		#print "$context\n"; 
		    my $abans="";
		    my $entremig="";
		    my $despres="";
		if ($context =~ /^(.*)$orig1 *( |\[\[|''|'''|'' *\[\[|''' *\[\[|\[\[.+\||'' *\[\[.+\||''' *\[\[.+\|)[ ]*$orig2(.*)$/) {
		    $abans=$1;
		    $entremig=$2;
		    $despres=$3;
		    my $frasecorregida = "$abans$sugg1$entremig$sugg2$despres";
		    $frasecorregida =~ s/^(.* [lLdD])''(.*)$/$1\{\{'\}\}'$2/g;
		    #print "$frasecorregida\n";

		    #my $motprevi=$abans;
		    #$motprevi =~ s/^.*\b([^\b].+ )$/$1/;
		    #$clauordenacio{$n}="$motprevi$suggestion$despres";

		    $clauordenacio{$n}="$sugg1$sugg2$despres";
		    push (@corregit, $frasecorregida);
		    push (@accio, "s");
		    $substituit=1;
		}
	    }
	    if ($suggestion =~ /^(el|El|la|La|de|De) (.+)$/) {
		my $sugg1=$1; my $sugg2=$2;
		$original =~ /([LlDd]['’])(.+)/;
		my $orig1=$1; my $orig2=$2;
		#print "$orig1 $orig2 $sugg1 $sugg2\n";
		my $abans="";
		my $entremig="";
		my $despres="";
		if ($context =~ /^(.*)$orig1 *( |\[\[|''|'''|'' *\[\[|''' *\[\[|\[\[.+\||'' *\[\[.+\||''' *\[\[.+\|)[ ]*$orig2(.*)$/) {
		#if ($context =~ /^(.*)$orig1(\[\[|''|'''|\[\[.+\|)$orig2(.*)$/) {
		    $abans=$1;
		    $entremig=$2;
		    $despres=$3;
		    my $frasecorregida = "$abans$sugg1 $entremig$sugg2$despres";

		    #my $motprevi=$abans;
		    #$motprevi =~ s/^.*\b([^\b].+ )$/$1/;
		    #$clauordenacio{$n}="$motprevi$suggestion$despres";

		    $clauordenacio{$n}="$sugg1$sugg2$despres";
		    push (@corregit, $frasecorregida);
		    push (@accio, "s");
		    $substituit=1;
		}
	    }
	    # Intenta fer la substitució de les contraccions
	    if ($suggestion =~ /^(al|als|del|dels|cal|cals|Al|Als|Del|Dels|Cal|Cals)$/) {
		my $sugg1=$1; #my $sugg2=$2;
		my $orig1=""; my $orig2="";
		$original =~ /(a|A|de|De|ca|Ca|d'|D') (el|els|El|Els)/;
		$orig1=$1; $orig2=$2;
		#print "$orig1 $orig2 $sugg1 $sugg2\n";
		#print "$context\n"; 
		if ($context =~ /^(.*)$orig1 *( |\[\[|''|'''|'' *\[\[|''' *\[\[|\[\[.+\||'' *\[\[.+\||''' *\[\[.+\|)[ ]*$orig2(.*)$/) {
		    my $abans=$1;
		    my $entremig=$2;
		    my $despres=$3;
		    my $frasecorregida = "$abans$sugg1$entremig$despres";
		    #$frasecorregida =~ s/^(.* [lLdD])''(.*)$/$1\{\{'\}\}'$2/g;
		    #print "$frasecorregida\n";

		    #my $motprevi=$abans;
		    #$motprevi =~ s/^.*\b([^\b].+ )$/$1/;
		    #$clauordenacio{$n}="$motprevi$suggestion$despres";

		    $clauordenacio{$n}="$sugg1$despres";
		    push (@corregit, $frasecorregida);
		    push (@accio, "s_arreglat");
		    $substituit=1;
		}
	    }
	}
=cut
	if (!$substituit)  {
            $clauordenacio{$n}="   NoTrobat: $original";
	    push (@corregit, $context);
	    push (@accio, "n");
	    #print $ofh2 "$context SuggerimentNoTrobat\n";
	}
	
    }
}

# EIXIDA
foreach my $num (sort {$clauordenacio{$a} cmp $clauordenacio{$b}} keys %clauordenacio) {
    print $ofh2 "$original[$num]|Ẁ|$titol[$num]|Ẁ|$errors[$num]|Ẁ|$suggeriments[$num]\n";
    print $ofh2 "$corregit[$num]|Ẁ|$accio[$num]\n\n";
}

close ($fh);
#close ($ofh);
close ($ofh2);

=mod
	my $longabans=$longitudabans-5;
	#if ($context =~ /(.{5})$original(.{5})/) {
	    #my $abans=$1;
            #my $original=$2;
	    #my $despres=$3;
	    #print $ofh "$title|$abans|$original|$despres|$suggestion\n";
	#}


	    my $mira=$abans.$original.$despres;
	    if ($mira =~ /( [lmnsdtLMNSDT][`´][Hh]?[aeiouàáèéìíòóùúAEIOUÀÁÈÉÌÍÒÓÙÚ]|[`´][sln][ ,;.])/) {
		print $ofh2 "ACCIÓ ([s]í, [n]o, [f]alsa alarma): s\n\n";
	    }
	    elsif ($mira =~ /([\d\(\s\-ã][`´]|[`´]\-)/) { 
		print $ofh2 "ACCIÓ ([s]í, [n]o, [f]alsa alarma): n\n\n";
	    }
	    else {
		print $ofh2 "ACCIÓ ([s]í, [n]o, [f]alsa alarma): revisa f\n\n";
	    }
=cut

