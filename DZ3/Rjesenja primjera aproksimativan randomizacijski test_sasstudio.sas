

%let n_perm=1000;

data grupa1;
  input ocjena @@;
  datalines;
  3.8 1.8 1.0 3.6 3.3 2.7 3.7 2.5 3.8 2.2 2.5 3.4 2.8
  ;
data grupa2;
  input ocjena @@;
  datalines;
4.0 2.5 3.6 2.5 3.6 1.7 2.8 2.6 2.7 2.5 2.6 2.2 2.5 2.3 1.3 3.2 2.6 1.0 2.6 0.0 2.8 3.0 2.5 3.1 4.0 2.9 2.7 3.9 3.4 3.6 3.1 0.7 0.7 2.2
  ;
data grupe;
 set grupa1 (in=a) grupa2;
 if a then grupa=1; else grupa=2;
 id=_N_;
 run;

 proc means data= grupe nway noprint;
  var ocjena;
  class grupa;
  output out=means mean=mean;
  run;

proc transpose data=means out=means_t prefix=_;
 var mean;
 id grupa;
 run;

 data means_t;
  set means_t;
  abs_diff=abs(_1-_2);
 run;


    proc plan seed=60359 ; 
      factors     rep=&n_perm random
                  id  = 47 /noprint
 ; 
      output out=approxperm;
run;

/* proc freq; table rep*id; run;*/


 data grupe_perm;
  do i=1 to &n_perm;
   do j=1 to 13;
    grupa=1;
	output;
   end;
   do j=14 to 47;
    grupa=2;
    output; 
   end;
   end;
   keep grupa;
   run;
 
   
data approxperm;
 merge approxperm grupe_perm;
run;

proc sort data=approxperm;
 by  id rep;
run;

data approxperm;
 merge approxperm grupe(drop=grupa);
 by id;
 run;

proc means data=approxperm nway noprint;
 var ocjena;
 class rep grupa;
 output out=means_perm mean=mean n=n;
 run;

 
proc transpose data=means_perm out=means_perm_t prefix=_;
 var mean;
 id grupa;
 by rep;
 run;

 data means_perm_t;
  set means_perm_t;
  if _N_=1 then set means_t(keep=abs_diff);
  abs_diff_perm=abs(_1-_2);
  N_sig=(abs_diff_perm ge abs_diff);
 run;

 proc means noprint;
  var N_sig;
  output out=p_sig sum=sum n=n;
  run;

 data p_sig;
  set p_sig;
  p_sig=(sum+1)/(n+1);
  run;

  proc print; run;

  proc datasets library=work;
   delete allperm approxperm grupe_perm;
  run;quit; 

proc ttest data=grupe;
 var ocjena;
 class grupa;
 run;

