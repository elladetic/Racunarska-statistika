libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";

proc means data = lib.law;
run;


ods noproctitle;
ods graphics / imagemap=on;

proc univariate data=LIB.LAW;
	ods select Histogram GoodnessOfFit ProbPlot;
	var LSAT;
	histogram LSAT / normal(mu=600 sigma=42);
	probplot LSAT / normal(mu=600 sigma=42);
run;


proc ttest data=lib.law h0=580 sides=L;
	var LSAT;
run;


proc power;
	onesamplemeans test = t sides = L
	nullmean= 580
	mean = 600
	stddev = 42
    ntotal = 50  to 500 by 50
    alpha = 0.01 0.05
    power = .;
run;

proc power;
	onesamplemeans test = t sides = L
	nullmean= 620
	mean = 600
	stddev = 42
    ntotal = 10  to 50 by 1
    alpha = 0.01 0.05
    power = .;
run;

proc power;
   onesamplemeans 
      mean   = 20.26666667
      ntotal = .
      stddev = 41.7945086
      alpha = 0.01 0.05
      sides = 1
      power  = 0.8;
run;


