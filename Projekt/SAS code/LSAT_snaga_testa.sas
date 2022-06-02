libname lib "/home/u58252441/sasuser.v94/RS/Projekt";
  
proc means data=lib.law;
output out=out;
var LSAT;
run;

/* mean = 600.26666667, std = 41.7945086, na temelju 15 podataka, tj. n = 15 */

/* ISPITIVANJE NORMALNOSTI */

ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=LIB.LAW;
	ods select Histogram;
	var LSAT;
	histogram LSAT;
run;ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=LIB.LAW;
	ods select Histogram;
	var LSAT;
	histogram LSAT / normal;
run;

proc univariate data=LIB.LAW;
	ods select Histogram GoodnessOfFit ProbPlot;
	var LSAT;

	/* Checking for Normality */
	histogram LSAT / normal(mu=600 sigma=42);
	probplot LSAT / normal(mu=600 sigma=42);
run;


proc ttest data=Lib.LAW h0=580 sides=l;
var LSAT;
run;


/* ZADNJE PITANJE - veličina uzorka potrebna za snagu testa 0.8*/ 

proc power;
   onesamplemeans
      mean   = 20.26666667 /*razlika između populacijskog meana i 580*/
      ntotal = .
      stddev = 41.7945086
      alpha = 0.01 0.05
      sides = 1
      power  = 0.8;
run;

/* n = 46 potrebno za alpha = 0.01, a n = 28 za alpha = 0.05 */

/* ovo mi je jako cudno, imam osjecaj da to nebi tak smijelo biti */
