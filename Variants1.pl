#!/usr/bin/env perl
use POSIX;

     my $file = $ARGV[0] ;
     my $length = $ARGV[1] ;     

### Threshold number of reads

     my $Thres = $ARGV[2] ;

## coverage percentage

     my $prc    = $ARGV[3] ;

### Length of protein

    open ( my $fl , '<', $file ) or die "Can't read file $file" ;

      chomp($length);
      chomp($prc);
      chomp($Thres);
   
     my $pre_threshold = $length * $prc ;  
     my $threshold = floor($pre_threshold); 

#   print join("\t", $length, $prc, $pre_threshold, $threshold),"\n";

   my %Mat ;

   while(my $ln = <$fl>){

       chomp($ln);

       ####
#       print $ln,"\n" ;
       ####
       
       
       if( $ln  !~  /SAMPLE.*/  ){

       my  ( $SAMPLE, $POSITION, $REF_CODON, $CODON, $REF_AA, $AA, $FWD_CNT, $FWD_DENOM, $REV_CNT, $REV_DENOM, $FWD_MEAN_MIN_QUAL, $REV_MEAN_MIN_QUAL, $FWD_FREQ, $REV_FREQ, $LOW_FREQ, $LOW_FREQ_DIRECTION, $FWD_STDDEV_MIN_QUAL,  $REV_STDDEV_MIN_QUAL,     $CNT ,    $DENOM ,  $PRP ) = split(/\t/, $ln);


         ####
#         print $ln,"\n" ;
         ####
       
       
       if($DENOM  >= $Thres){
            $Mat{$POSITION}{$AA}{$CODON} = $ln ;   
	    #print join("\t", $POSITION, $AA, $CODON),"\n";
                 }
               }
            }

   my @scl  = sort { $a <=> $b }(keys %Mat) ;   
   my $qt = scalar @scl ;
    
     #print "$qt  $threshold\n";

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
 
