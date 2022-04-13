%LET SEED = 22334;
%LET NREP = 1000;

DATA BERN;
	CALL STREAMINIT(&SEED);

	DO REP=1 TO &NREP;
		X=RAND ('BERNOULLI', 0.25);
		OUTPUT;
	END;
	drop rep;
RUN;

proc means data = BERN mean median std;
var X;
run;

PROC FREQ DATA=BERN;
RUN;