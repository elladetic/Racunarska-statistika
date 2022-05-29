%include "/home/u58223001/RS zadaće/Zadaća 7/jackboot.sas";

%let nboot=1000;
%let seed=3774;

data podatci(keep= SepalLength  SepalWidth);
	set sashelp.iris;
	Species="Virginica";
run;

/*(a) dio */
proc reg data=podatci outest=out;                                                                                                                                                                                                                                 
  model SepalWidth=SepalLength; 
run; quit;

proc reg data=podatci noprint outest=out(where=(_type_='PARMS')                                                                                
           rename=(SepalLength=bootreg)                                                                                                          
           keep=SepalLength _type_);                                                                                     
  model SepalWidth=SepalLength; 
run; quit;


%macro analyze(data=podatci,out=out);
		proc reg data=&data noprint outest=&out(where=(_type_='PARMS')                                                                                
                  rename=(SepalLength=bootreg)                                                                                                          
                  keep=SepalLength _type_  &by);                                                                                     
    model SepalWidth=SepalLength; 
	 %bystmt;
    run; quit;
%mend;

%boot(data=podatci,random=&seed, samples=&nboot);

/*Procjena regresijskog koeficijenta bootstrap metodom iznosi -0.062958,
dok je procjena pristranosti -.001072756. */
/*Procjena standardne pogreške kod neparametarskog bootstrap pristupa iznosi 0.039056,
dok je procjena standardne greške korištenenjem PROC REG na originalnim podatcima 0.04297 */

/*(b) i (c) dio*/
%bootci(PCTL, alpha=0.05)
%bootci(PCTL, alpha=0.1) 
%bootci(BC, alpha=0.05) 
%bootci(BC, alpha=0.1)


/*(d) dio */
sasfile podatci load;
proc surveyselect data=podatci out=outboot /* 2 */
seed=4455 
method=urs 
samprate=1 
outhits 
rep=1000; 
run;
sasfile podatci close;

proc reg data=outboot noprint outest=outall(keep=SepalLength);
by replicate;
model SepalWidth=SepalLength;
run;

proc means data=outall mean std;
var SepalLength;
output out=outmeans mean= /autoname;
run;

data _NULL_;
 set outmeans end=last;
 if last then call symput('bp',put(SepalLength_mean,best10.));
run;

data _NULL_;
 set out end=last;
 if last then call symput('pp',put(bootreg,best10.));
run;

data pristranost;
 bias= &bp-&pp;
run;

proc print data=pristranost;
run;

/* bootstrap procjena za regresijski koeficijent uz SepalLength iznosi -0.0659689,
dok je bootstrap procjena standardne pogreške za taj isti koeficijent 0.0398948*/

proc univariate data=outall noprint;
var SepalLength;
output out=final pctlpts=2.5, 97.5 pctlpre=ci_ ;
run;

proc print data=final;
run;

proc univariate data=outall noprint;
var SepalLength;
output out=final pctlpts=5, 95 pctlpre=ci_ ;
run;
 
proc print data=final;
run;


ods listing close;
ods html close;

/*(e) dio */
ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=WORK.BOOTDIST;
	ods select Histogram;
	var bootreg;
	histogram bootreg / kernel;
	inset n median std skewness kurtosis / position=ne;
run;