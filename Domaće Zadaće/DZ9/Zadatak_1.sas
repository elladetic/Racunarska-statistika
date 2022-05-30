*učitavanje podataka;
data Gossypol;
      input Doza n;
      do i=1 to n;
         input Porast @@;
		 id+1;
         output;
         end;
      datalines;
   1 12
   179 193 133 170 213 114 104 128 158 134 108 126
   2 17
   130 87 135 116 118 165 151 59 126 64 78 94 150 160 122 110 178
   ;
   run;

*****************************A i B DIO ***********************************;
%let seed=47822;

proc means data=gossypol; *proučavamo svaku dozu posebno;
	var porast;
	by doza;
run;

proc means data=gossypol nway noprint;
  	var porast;
  	output out=out mean=mean;
run; 
 
data _NULL_;
  	set out;
  	call symput("mean_data",mean);
run;
  
/*** spremamo te podatke za daljnje korištenje ***/

proc means data=gossypol nway noprint;
  	var porast;
  	class doza;
  	output out=out mean=mean;
run; 

data _NULL_;
  	set out;
  	if doza=1 then call symput("mean1",mean);
  	else 			  call symput("mean2",mean);
run;

%put mean1=&mean1 mean2=&mean2;

/*** moramo centrirati podatke ***/

  data grupa1(keep=porast);
  	set gossypol(where=(doza=1));
  run;
  data grupa2(keep=porast);
  	set gossypol(where=(doza=2));
  run;
  data grupa1_centrirana;
   set grupa1;
   porast=porast-&mean1;
   run;
  data grupa2_centrirana;
   set grupa2;
   porast=porast-&mean2;
   run;

                                                                                                        

/*** GRUPA 1 ***/

%let dat=grupa1_centrirana;
%let bsamples=1000;

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
%let dat=grupa2_centrirana;
%let bsamples=1000;
 
sasfile &dat load; /* 1 */
proc surveyselect data=/*YourData*/ &dat out=outboot2 /* 2 */
seed=&seed /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=&bsamples; /* 7 */
run;
sasfile &dat close; /* 8 */


data outboot;
 set outboot1(in=g1) outboot2;
 if g1 then grupa=1; else grupa=2;
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
ods noresults;
ods output ttests=boot_t(where=(method="Pooled"));
proc ttest data=outboot;
 var porast;
 class grupa;
 by Replicate;
run;
%odson;
 

 
ods select ttests ;
ods output ttests=actual_t(where=(method="Pooled"));
 proc ttest data=gossypol;
 var porast;
 class doza;
 run;


data boot_and_actual_t;
   set boot_t;
   if _N_=1 then set actual_t(rename=(tvalue=actual_tvalue));
 
   prob_left =(tvalue < -abs(actual_tvalue));
   prob_right=(tvalue > abs(actual_tvalue));

   prob=sum(prob_left,prob_right);
   run;

   proc means data= boot_and_actual_t mean;
    var prob_left prob_right prob;
	run;

* p-value za obostranu hipotezu je 0.058 - ne odbacujemo H_0, dok je 
p-vrijednost za jednostranu hipotezu 0.0240000 - odbacujemo H_0;


***************************** C DIO ***********************************;

* dodajemo još nove podatke;
data Gossypol;
  input Doza n;
  do i=1 to n;
    input Porast @@;
	  id+1;
    output;
    end;
  datalines;
   1 12
   179 193 133 170 213 114 104 128 158 134 108 126
   2 17
   130 87 135 116 118 165 151 59 126 64 78 94 150 160 122 110 178
   3 10
	101 68 46 94 79 81 55 70 108 92
   ;
run;

proc means data=gossypol;
	var porast;
	by doza;
run;


proc means data=gossypol nway noprint;
  	var porast;
  	class doza;
  	output out=out mean=mean;
run; 

data _NULL_;
  	set out;
  	if doza=1 then call symput("mean1",mean);
  	else if (doza=2) then	 call symput("mean2",mean);
  	else if (doza=3) then call symput("mean3",mean);
run;

  %put mean1=&mean1 mean2=&mean2;



  data grupa1(keep=porast);
  	set gossypol(where=(doza=1));
  run;
  data grupa2(keep=porast);
  	set gossypol(where=(doza=2));
  run;
  data grupa3(keep=porast);
  	set gossypol(where=(doza=3));
  run;
  data grupa1_centrirana;
   set grupa1;
   porast=porast-&mean1;
   run;
  data grupa2_centrirana;
   set grupa2;
   porast=porast-&mean2;
   run;
  data grupa3_centrirana;
   set grupa3;
   porast=porast-&mean3;
   run;
 
/*** Neparametarski bootstrap ***/
                                                                                                        

/*** GRUPA 1 ***/

%let dat=grupa1_centrirana;
%let bsamples=1000;

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

%let dat=grupa2_centrirana;
%let bsamples=1000;
 
sasfile &dat load; /* 1 */
proc surveyselect data=/*YourData*/ &dat out=outboot2 /* 2 */
seed=&seed /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=&bsamples; /* 7 */
run;
sasfile &dat close; /* 8 */

/*** GRUPA 3 ***/

%let dat=grupa3_centrirana;
%let bsamples=1000;
 
sasfile &dat load; /* 1 */
proc surveyselect data=/*YourData*/ &dat out=outboot3 /* 2 */
seed=&seed /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=&bsamples; /* 7 */
run;
sasfile &dat close; /* 8 */


data outboot;
 set outboot1(in=g1) outboot2(in=g2) outboot3;
 if g1 then grupa=1;
 else if g2 then grupa=2;
 else grupa=3;
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

data gossypol1;
	set gossypol;
	porast=porast-&mean_data;
run;

%odsoff;
 /*ods select OverallANOVA;*/
 ods output OverallANOVA=actual_F(keep= Source Fvalue);
 ods trace on;   
 proc glm data=Gossypol1;
 class doza;
 model porast=doza;
 run;
 ods trace off;  
 
 data actual_F1(keep=Fvalue);
 	set actual_F(where=(Source='Model'));
 run;
 
 proc sort data=outboot out=outboot;
 by replicate;
 run;
 
 /*ods select OverallANOVA;*/
 ods output OverallANOVA=boot_F(keep= Source Fvalue);
 proc glm data=outboot;
 class grupa;
 model porast=grupa;
 by replicate;
 run;
%odson;
 
  data boot_F1(keep=Fvalue);
 	set boot_F(where=(Source='Model'));
 run;
 
 data boot_and_actual_F;
   set boot_F1;
   if _N_=1 then set actual_F1(rename=(Fvalue=actual_Fvalue));
 
   /*prob_left =(Fvalue < -abs(actual_Fvalue));*/
   prob_right=(Fvalue > actual_Fvalue);

   /*prob=sum(prob_left,prob_right);*/
   run;

   proc means data= boot_and_actual_F mean;
    var /*prob_left*/ prob_right /*prob*/;
	run;
	
* postoji statisticki značajna razlika;