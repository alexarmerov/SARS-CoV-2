#!/usr/bin/env perl
use POSIX;

# This script removes codons with a depth less than a user-specified threshold. The script then determines the proportion of protein positions with sufficient coverage; if this proportion is less than a user-specified threshold the pipeline stops at this point raising a message. 

     my $file   = $ARGV[0] ;
     my $length = $ARGV[1] ;     
     my $Thres  = $ARGV[2] ;
     my $prc    = $ARGV[3] ;

# Parameters 
# length: protein length in amino acids                                                           
# Thres: minimum number of reads covering a position                                              
# prc: minimum percentage of protein length covered by reads  


    open ( my $fl , '<', $file ) or die "Can't read file $file" ;

      chomp($length);
      chomp($prc);
      chomp($Thres);
   
     my $pre_threshold = $length * $prc ;  
     my $threshold = floor($pre_threshold); 

     my %Mat ;

   while(my $ln = <$fl>){

       chomp($ln);

       if( $ln  !~  /SAMPLE.*/  ){

	   my  ( $SAMPLE, $POSITION, $REF_CODON, $CODON, $REF_AA, $AA, $FWD_CNT, $FWD_DENOM, $REV_CNT, $REV_DENOM, $FWD_MEAN_MIN_QUAL, $REV_MEAN_MIN_QUAL, $FWD_FREQ, $REV_FREQ, $LOW_FREQ, $LOW_FREQ_DIRECTION, $FWD_STDDEV_MIN_QUAL,  $REV_STDDEV_MIN_QUAL, $CNT, $DENOM,  $PRP) = split(/\t/, $ln);


## codons with sufficient coverage

       if($DENOM  >= $Thres){
            $Mat{$POSITION}{$AA}{$CODON} = $ln ;   
                 }
               }
            }

   my @scl  = sort { $a <=> $b }(keys %Mat) ;   
   my $qt = scalar @scl ;
    

## Assess protein coverage

   if( $qt >= $threshold ) {

        while( my $pos = shift @scl  ){    

           my  @AA = keys %{$Mat{$pos}};                  

	   while( my $aa = shift @AA  ){
 
	     my @codon = keys %{$Mat{$pos}{$aa}};

             while( my $cd = shift @codon  ){

		 print $Mat{$pos}{$aa}{$cd},"\n";

	           }
                 }
               }
            }
else{
 
    print "Insufficient protein coverage by reads\n";

 }
