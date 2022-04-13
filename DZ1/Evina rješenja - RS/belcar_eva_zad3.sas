%LET SEED = 44566;
%LET NREP = 1000;

DATA mixnorm;
	CALL STREAMINIT(&SEED);

	DO REP=1 TO &NREP;
		X=RAND ('BERNOULLI', 0.8);
		IF X = 1 then
			do;
				X =  RAND ("NORM");
			end;
		ELSE
			do;
				X =  RAND ("NORM",0,5); /*tu treba biti 5 ili 25*? ovdje se unosi std*/
			end;
		OUTPUT;
	END;
	drop rep;
RUN;

/*Prikaz standardne normalne i mixed - kako da usporedim točno s normalnom graficki? ne znam izkodirati*/

ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=WORK.MIXNORM;
	ods select Histogram;
	var X;
	histogram X / normal;
run;

/*kak da dodam stand.norm?*/

proc means data = mixnorm mean std skewness kurtosis;

/*-0.1018320	5.5908463	-0.6105428	7.2203861*/
/*Za normalnu je: 0, 1, 0, 0 -> 4. moment se dosta razlikuje*/
/*std bi se isto trebala dosta razlikovati, po primjeru iz rada ovo se cini oke*/
