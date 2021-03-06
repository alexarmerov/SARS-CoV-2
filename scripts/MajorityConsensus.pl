#!/usr/bin/env perl
use strict;
use warnings;

     my $file = $ARGV[0] ;
     my $majority = $ARGV[1] ;   
     my $synonyme = $ARGV[2] ;       
     my $non_synonyme = $ARGV[3] ;
     my $threshold_reads = $ARGV[4] ;

open ( my $mj , '>', $majority ) or die "Can't read file $majority" ;
open ( my $sn , '>', $synonyme ) or die "Can't read file $synonyme" ;
open ( my $ns , '>', $non_synonyme ) or die "Can't read file $non_synonyme" ;    

  open ( my $fl , '<', $file ) or die "Can't read file $file" ;

  my %lines ; 
  my %Variation ; 
  my %Pre_majority ;
  my %Majority ; 

  while(my $ln = <$fl>){

       chomp($ln);

        my @ar  = split(/\t/, $ln);
        my $position = $ar[1] ;        
        my $prp = $ar[20] ;         
     

          $position =~  s/0*([1-9][0-9]*)/$1/ ; 
          $ar[1] = $position ;
          my $Frequency = $prp * 100 ;
          my $new_line = join("\t", @ar, $Frequency);                                 
          $lines{$position}{$new_line} = "";
 	  $Pre_majority{$position}{$Frequency}  = $new_line ;

         }


     my @pre  = sort { $a <=> $b }( keys  %Pre_majority );
 
   while(my $posi  = shift @pre) {

       my @Freqs = sort { $b <=> $a } (keys %{$Pre_majority{$posi}})     ;
       my $consensus = shift @Freqs ;
       my @ar = split("\t", $Pre_majority{$posi}{$consensus});
       my $ref_cod = $ar[3] ;
       my $ref_aa = $ar[5] ;
       my $info = join("\t", $ref_cod, $ref_aa);                
       $Majority{$posi}= $info ;

             }


   my @Positions = sort { $a <=> $b   } keys %lines ;

  while(my $ps =  shift @Positions){

      my @Lines = keys %{$lines{$ps}};

      while( my $ln = shift @Lines ){

      # print $ln,"\n";
	  my @ar  = split(/\t/, $ln);
	  my $position = $ar[1] ;
          my $Frequency = $ar[21] ;
	  my $total_reads = $ar[19] ;
	  my $reads_subs = $ar[18] ;
	  my ($cod_ref, $aa_ref) = split(/\t/, $Majority{$position});
	  $ar[2]  = $cod_ref ;
	  $ar[4]  = $aa_ref ;
          my $codon = $ar[3] ;
          my $aa = $ar[5] ; 

   
 if(($Frequency  >= 5) and ( $total_reads >= $threshold_reads ) and ( $reads_subs >= 5 )){
    
	  if(($ar[2] eq $codon) and ($ar[4] eq $aa)){
	      print $mj  join("\t",  @ar),"\n";
	         }
          elsif(( $ar[4] eq $aa ) and ($ar[2] ne $codon)){
	      print  $sn join("\t",  @ar),"\n";
	        }
            else{       
               print  $ns join("\t",  @ar),"\n";           
	       }
            }   
         }
      }


close $ns ;
close $sn ;
close $mj ;
