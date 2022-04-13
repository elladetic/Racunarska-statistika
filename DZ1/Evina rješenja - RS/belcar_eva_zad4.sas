%LET SEED = 44566;
/*%LET NREP = 1000; ne znam jel ovo molgu oduzimati*/

DATA armethod;
	CALL STREAMINIT(&SEED);
	c = 1/beta(2,3)*(1/3)*(2/3)**2;
	NREP = 0;

	DO WHILE (NREP < 1000);
		Y=RAND ('uniform');
		U=RAND ('uniform');
		IF pdf('beta',Y,2,3)>= U*c*pdf('uniform',Y) then
			do;
				X = Y;
				NREP+1;
			end;
		ELSE X = 0;
		OUTPUT;
	END;	
RUN;

data armethod;
	set armethod;
	if X = 0 then delete;
	drop c nrep;
run;



ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=WORK.ARMETHOD;
	ods select Histogram;
	var X;
	histogram X;
run;

proc univariate data=WORK.ARMETHOD;
	ods select Histogram GoodnessOfFit ProbPlot;
	var X;

	/* Fitting Distributions */
	histogram X / beta(alpha=2 beta=3 sigma=1 theta=0);
	probplot X / beta(alpha=2 beta=3 sigma=1 theta=0);  /*jel ovo ppplot zapravo? kolko sam guglala mi se cini da je*/
run;

/* KS test: veliki p-value: ne odbacujemo nultu hipotezu o pripadanju beta distribuciji*/


/*ovo mi je isto kao i ppplot, ali izbaci jos neke dodatne stvari*/

proc univariate data=work.armethod;
   var X;
   ppplot X / beta(alpha=2 beta=3 sigma=1 theta=0);
run;