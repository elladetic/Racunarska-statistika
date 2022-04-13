/* (a) */

%LET SEED = 65789;
%LET NREP = 1000;

DATA LOGNORMALNA;
	CALL STREAMINIT(&SEED);

	DO REP=1 TO &NREP;
		X=RAND ("LOGN");

		/*po defaultu log-scale = 0 (jel to isto ko i mu?), shape (sigma) = 1*/
		OUTPUT;
	END;
	drop rep;
RUN;

ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=WORK.LOGNORMALNA;
	ods select Histogram;
	var X;
	histogram X;
run;

proc univariate data=WORK.LOGNORMALNA;
	/*kak da izbacim rep? jel mi ovo dosta za racunanje sd,mean,kurtosis,skewness etc?*/
	ppplot x / lognormal(theta=0 zeta=0);
run;

proc univariate data=WORK.LOGNORMALNA;
	ods select Histogram GoodnessOfFit ProbPlot;
	var X;

	/* Fitting Distributions */
	histogram X / lognormal(sigma=1 theta=0 zeta=0);

	/*ovdje je pisalo est umjesto 1 i 0, ali mislim da ovak
	jer trazi usporedbu s teroijskom lognorm. distr*/
	probplot X / lognormal(sigma=1 theta=0 zeta=0);

	/*kak bi ukomponirala ppplot?*/
run;

/*KS: ne mogu odbaciti nultu hipotezu da pripada lognormalnoj s danim parametrima*/


/* negdje na internetu sam nasla formule:
	m=2ln(mi)-0.5ln(SIGMA^2+mi^2)
	sigma^2=-2ln(mi)+ln(SIGMA^2+mi^2)
	
	nes mi je krivo ili ne znam povezati?
	možda sam trebala nes drugo uvrsiti u rand log normal
*/


/*
skewnes je pozitivan -> naginje lijevo!
kurtosis je puno veci od 16 ->leptokurtic (više i tanje od normalne)
*/



/* (b) PROUČI KAJ SU ZAPRAVO THETA,SIGMA I ZETA */


%LET SEED = 34567;
%LET NREP = 1000;

DATA LOGNORMALNA2;
	CALL STREAMINIT(&SEED);

	DO REP=1 TO &NREP;
		X=RAND ("LOGN",1,0.5);
		OUTPUT;
	END;
	drop rep;
RUN;

ods noproctitle;
ods graphics / imagemap=on;

/* Exploring Data */
proc univariate data=WORK.LOGNORMALNA2;
	ods select Histogram;
	var X;
	histogram X;
run;

proc univariate data=WORK.LOGNORMALNA2;
	ppplot x / lognormal(sigma =0.5 theta=est zeta=1);
run;

proc univariate data=WORK.LOGNORMALNA2;
	ods select Histogram GoodnessOfFit ProbPlot;
	var X;

	/* Fitting Distributions */
	histogram X / lognormal(sigma=0.5 theta=est zeta=1);
	probplot X / lognormal(sigma=0.5 theta=est zeta=1);
run;


/* (c)  QQplot Manually*/

proc sort data = lognormalna2 out= QQ; by x; run;

data QQ;
set QQ nobs = Nobs;
v = (_N_ - 0.375)/(Nobs + 0.25);
q = quantile ("Lognormal",v);
label x = "Oserved Data" q = "Lognormal Quantiles";
run;

proc sgplot data=QQ;
	scatter x=q y=x;
	xaxis grid; yaxis grid;
run;

/*cudno ispada za drugi set podataka, ne kuzim brojeve u 112. redu*/