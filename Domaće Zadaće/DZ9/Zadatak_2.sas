
   data pcb;
    input gs elisa @@;
	datalines;
	76 81  150 152 115 129
	50 83  192 152 166 140
	59 84  171 172 205 212
	92 92  177 172 337 309
	70 93   28 106 334 320
	99 100  58 109 309 358
   176 143 106 121 310 429
   156 145  94 122 568 510
   ;
   run;

   proc reg data=pcb outest=parest(where=(_type_='PARMS') keep=gs _type_ _RMSE_ intercept);
   model elisa=gs;
   run; quit;

   data _NULL_;
    set parest;
     call symput("alpha",intercept);
	 call symput("beta",gs);
	 call symput("sigma",_RMSE_);
	 run;
	 %put alpha=&alpha beta=&beta sigma=&sigma;

	data ostatci (keep=ost);
		set pcb;
		ost=elisa-&alpha-&beta*gs;
	run;
	proc means data=ostatci std;
	run;

/* t(5) distribucija greske */
title "t(5) distribucija";
	
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
	 
%let rep=10000;
%let seed=12844;

%let df=5; 
data boot_data;
call streaminit(&seed);    
 set pcb;
 do rep=1 to &rep;
  elisaboot=&alpha+&beta*gs+(&sigma*sqrt(3/5))*RAND('t', &df);
 end;
 run;

proc sort data=boot_data;
 by rep;
run;

 %odsoff;
 proc reg data=boot_data noprint outest=parest(where=(_type_='PARMS') keep=gs _type_ _RMSE_ intercept rep);
 model elisaboot=gs;
 by rep;
 run;
%odson;
  
data boot_dist;
 set parest;
 boot_fn200=probnorm((100-intercept-gs*200)/(_RMSE_)); 
 run;

proc means data=boot_dist mean std p95;
 var boot_fn200;
 run;
title1;

/* t(6) distribucija greske */
title "t(6) distribucija";
%let rep=10000;
%let seed=12844;



%let df=6; 
data boot_data;
call streaminit(&seed);    
 set pcb;
 do rep=1 to &rep;
  elisaboot=&alpha+&beta*gs +(&sigma/sqrt(1.5))*RAND('T', &df);
  output;
 end;
 run;

proc sort data=boot_data;
 by rep;
run;

%odsoff;
 proc reg data=boot_data noprint outest=parest(where=(_type_='PARMS') keep=gs _type_ _RMSE_ intercept rep);
 model elisaboot=gs;
 by rep;
 run;
%odson;
  
data boot_dist;
 set parest;
 boot_fn200=probnorm((100-intercept-gs*200)/(_RMSE_)); 
 run;

proc means data=boot_dist mean std p95;
 var boot_fn200;
 run;
 

/* Weibull() distribucija greske */
title "Weibull distribucija";

proc univariate data=ostatci;
   histogram ost/ weibull(theta=est shape=est scale=est); 
run;
	 
%let rep=10000;
%let seed=12844;

data boot_data;
call streaminit(&seed);    
 set pcb;
 do rep=1 to &rep;
  elisaboot=&alpha+&beta*gs +(RAND('WEIBull',1.442152,54.2573)-49.2649+0.03148);
 output;
 end;
 run;
 
 data boot_data_test(keep=osta);
    set boot_data;
	osta=elisaboot-&alpha-&beta*gs;
run;

proc means data=boot_data_test;
run;

proc univariate data=boot_data_test noprint;
	histogram osta / weibull(theta=est shape=est scale=est);
run;


proc sort data=boot_data;
 by rep;
run;

 %odsoff;
proc reg data=boot_data noprint outest=parest(where=(_type_='PARMS') keep=gs _type_ _RMSE_ intercept rep);
 model elisaboot=gs;
 by rep;
 run;
%odson;
  
data boot_dist;
 set parest;
 boot_fn200=probnorm((100-intercept-gs*200)/_RMSE_);

 run;

proc means data=boot_dist mean std p95;
 var boot_fn200;
 run;


/* Lognormal() distribucija greske */
title "Lognormal distribucija";

proc univariate data=ostatci;
   histogram ost/ lognormal(theta=est shape=est scale=est); 
  run;

%let rep=10000;
%let seed=12844;

data boot_data;
call streaminit(&seed);    
 set pcb;
 do rep=1 to &rep;
  elisaboot=&alpha+&beta*gs +(RAND('lognormal',4.044783,0.517176)-64.8879-0.381162);
  output;
 end;
 run;

data boot_data_test(keep=osta);
    set boot_data;
	osta=elisaboot-&alpha-&beta*gs;
run;

proc means data=boot_data_test;
run;

proc univariate data=boot_data_test noprint;
	histogram osta / lognormal(theta=est shape=est scale=est);
run;


proc sort data=boot_data;
 by rep;
run;

 %odsoff;
 proc reg data=boot_data noprint outest=parest(where=(_type_='PARMS') keep=gs _type_ _RMSE_ intercept rep);
 model elisaboot=gs;
 by rep;
 run;
%odson;
  
  data boot_dist;
 set parest;
 boot_fn200=probnorm((100-intercept-gs*200)/_RMSE_);
 run;

proc means data=boot_dist mean std p95;
 var boot_fn200;
 run;
