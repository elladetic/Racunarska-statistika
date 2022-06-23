data  pizza;
 input tijesto $ kvaliteta @@;
 datalines;
s 4.4 s 4.7 s 3.8 s 4.2 s 5.2 s 4.5 s 4.5 
n 5.3 n 4.8 n 5.6 n 4.9 n 5.1 n 4.8
;
run;

**********************A DIO****************************;

proc ttest data=pizza sides=2;
 var kvaliteta;
 class tijesto;
run;

proc ttest data=pizza sides=U;
 var kvaliteta;
 class tijesto;
run;

proc ttest data=pizza sides=L;
 var kvaliteta;
 class tijesto;
run;

*pvalue za jednakost varijanci jednaka 0.5252 - ne odbacujemo hipotezu o jednakosti varijanci. 
p-vrijednost  za dvostrani test je 0.0154 - odbacujemo hipotezu o jednakosti kvaliteta;



**********************B DIO****************************;
/*** Analiza grupa ***/

 proc means data=pizza nway noprint;
  var kvaliteta;
  class tijesto;
  output out=out mean=mean;
 run; 

 data _NULL_;
  set out;
  if tijesto='n' then call symput("mean1",mean);
  else 			   call symput("mean2",mean);
  run;

  %put mean1=&mean1 mean2=&mean2;

/*** Centriranje ***/

  data grupa1_centrirana;
   set pizza(where=(tijesto='n'));
   kvaliteta=kvaliteta-&mean1;
   run;
  data grupa2_centrirana;
   set pizza(where=(tijesto='s'));
   kvaliteta=kvaliteta-&mean2;
   run;

/*** Neparametarski bootstrap ***/

/*** GRUPA 1 ***/
%let var=kvaliteta;
%let dat=grupa1_centrirana;
%let seed=34567;
%let bsamples=500;
 
sasfile &dat load; /* 1 */
proc surveyselect data=/*YourData*/ &dat out=outboot1 /* 2 */
seed=&seed /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=&bsamples; /* 7 */
run;
sasfile &dat close; /* 8 */

/*** GRUPA 2 ***/

%let var=kvaliteta;
%let dat=grupa2_centrirana;
%let seed=77890;
%let bsamples=500;
 
sasfile &dat load; /* 1 */
proc surveyselect data=/*YourData*/ &dat out=outboot2 /* 2 */
seed=&seed /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=&bsamples; /* 7 */
run;
sasfile &dat close; /* 8 */


/*** spajanje (konkatenacija) outboot1 i outboot2 datasetova ***/
data outboot;
 set outboot1(in=g1) outboot2;
 if g1 then tijesto='n'; else tijesto='s';
 run;

proc sort data=outboot;
 by Replicate;
run;


%macro ODSOff(); /* Call prior to BY-group processing */
ods graphics off;
ods exclude all;
ods noresults;
%mend;

%macro ODSOn(); /* Call after BY-group processing */
ods graphics on;
ods exclude none;
ods results;
%mend;

%odsoff;

ods output ttests=boot_t(where=(method="Pooled"));
proc ttest data=outboot sides=2;
 var kvaliteta;
 class tijesto;
 by Replicate;
run;
%odson; 



ods output ttests=actual_t(where=(method="Pooled"));
 proc ttest data=pizza sides=2;
 var kvaliteta;
 class tijesto;
 run;

data boot_and_actual_t;
   set boot_t actual_t;   
run;


data boot_and_actual_t2;
   set boot_t;
   if _N_=1 then set actual_t(rename=(tvalue=actual_tvalue));
 
   prob_left =(tvalue < -abs(actual_tvalue));
   prob_right=(tvalue > abs(actual_tvalue));

   prob=sum(prob_left,prob_right);
   run;
   
proc means data=boot_and_actual_t2 mean;
	var prob_left prob_right prob;
run;


data boot_and_actual_t3;
    set boot_and_actual_t2;
    probI=1-prob;
    prob_leftI=1-prob_left;
    prob_rightI=1-prob_right;
run;

proc freq data=boot_and_actual_t3;
tables probI / binomial;
tables prob_leftI / binomial;
run;

* pvalue za obostrani test 0.0240000,za jednostrani 0.0120000.
U oba slucaja odbacujemo hipotezu o jednakosti ocekivane kvalitete tijesta;
