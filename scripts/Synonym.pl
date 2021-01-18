#!/usr/bin/env perl

     my $file = $ARGV[0] ;
     my $genomic_position = $ARGV[1] ;

### Length of protein

     open ( my $fl , '<', $file ) or die "Can't read file $file" ;

  my %Mat ;

  while(my $ln = <$fl>){

       chomp($ln);

        my @ar  = split(/\t/, $ln);
        my $position = $ar[1] ;        
        my $cod_ref =  $ar[2];
        my $codon = $ar[3] ;
        my $aa_ref = $ar[4];
        my $aa = $ar[5] ;
        my $correction = 0;
        my $pos_muta = 0;
        my $number_reads = $ar[18] ;     
        my $total = $ar[19] ;
        my $fq = $ar[21] ;

         if($position != 1){
	     $correction = $position -1 ;
                  }

       $pos_muta = $genomic_position+($correction*3);
 
         my @codon_ref  = split(//, $cod_ref);
         my @codon_syn = split(//, $codon);

         if( $codon_ref[0] ne $codon_syn[0] ){
       
        my $local_pos= $pos_muta ;         
  print join("\t", $position, $cod_ref, $codon, $aa_ref  ,  $aa , $codon_syn[0], $local_pos, $number_reads, $total, $fq ),"\n";

                  }

       if( $codon_ref[1] ne $codon_syn[1] ){

    my $local_pos= $pos_muta +1 ; 
  print join("\t", $position, $cod_ref, $codon, $aa_ref  ,  $aa , $codon_syn[1], $local_pos, $number_reads, $total, $fq ),"\n";

             }
       
       if( $codon_ref[2] ne $codon_syn[2] ){

      my $local_pos= $pos_muta +2 ;
  print join("\t", $position, $cod_ref, $codon, $aa_ref  ,  $aa , $codon_syn[2], $local_pos, $number_reads, $total, $fq ),"\n";

	         }
         }
        
      
