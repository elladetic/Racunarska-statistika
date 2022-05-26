%LET SEED = 7736;
%LET N = 100;

DATA BUYERS;
	CALL STREAMINIT(&SEED);
	DO REP=1 TO &N;
		X=RAND ('BERNOULLI', .25);
		IF X = 1 then do;
				time =  RAND('EXPOnential', 2.5);
			end;
		ELSE do;
				time =  RAND('ERLAng', 4);
			end;
		OUTPUT;
	END;
	drop rep;
RUN;

title "Vrijednosti prva četiri momenta za generirane podatke";
proc means data = buyers mean std skewness kurtosis;
	var time;
run; 

title "Ukupno vrijeme kupovine svih kupaca";
proc sql;
    select sum(time) as Sum_Time
    from work.buyers;
quit;

