*učitavanje podataka;
data RAZRED;
	input Name $ Height Weight @@;
	datalines;
	Alfred  81.0 130.5   Alice  56.5  84.0   Barbara 65.3  98.0
	Carol   62.8 102.5   Henry  61.5 101.5   James   76.3 170.0
	Jane    71.8  94.5   Janet  62.5 112.5   Jeffrey 61.5  85.0
	John    59.0  99.5   Joyce  65.3 150.5   Judy    64.3  90.0
	Louise  56.3  77.0   Mary   66.5 115.0   Philip  72.5 152.0
	Robert  64.8 158.0   Ronald 67.0 137.0   Thomas  57.5  85.0 
; 
run; 

*a dio;
data razred;  *rename columns;
	set razred; 
	rename Height = Visina 
       	Weight = Tezina; 
RUN;

proc sql; *konvertiranje;
   update Razred
      set 	Visina = Visina * 2.54,
      		Tezina = Tezina * 0.45359237;
RUN; 

*b dio;
title "Vrijednosti prva četiri momenta za visinu";
proc means data=razred nway mean std kurt skew;
	var Visina;
	output out = Visina_values mean = mean std = std kurt = kurt skew = skew;
run;
title "Vrijednosti prva četiri momenta za težinu";
proc means data=razred nway mean std kurt skew;
	var Tezina;
	output out = Tezina_values mean = mean std = std kurt = kurt skew = skew;
run;  


*algoritam za računanje koeficijenta;
%macro fleishman;
   /*	This program calculates the coefficients for Fleishman's power transformation in order     */
   /*   to obtain univariate non-normal variables.  For references, see Allen I. Fleishman, (1978).*/
   /*   A method for simulating non-normal distributions, Psychometrika, 43, 521-532.  Also see    */
   /*   Vale, C. David and Maurelli, Vincent A.  (1983).  Simulating multivariate non-normal       */
   /*   distributions, Psychometrika, 48, 465-471.                                                 */                   

PROC IML;

 use skewkurt; 
 read all var{skewness kurtosis} into skewkurt; 

START NEWTON;
  RUN FUN;
  DO ITER = 1 TO MAXITER
  WHILE(MAX(ABS(F))>CONVERGE);
        RUN DERIV;
        DELTA=-SOLVE(J,F);
        COEF=COEF+DELTA;
        RUN FUN;
  END;
FINISH NEWTON;
MAXITER=25;
CONVERGE=.000001;
START FUN;
  X1=COEF[1];
  X2=COEF[2];
  X3=COEF[3];
  F=(X1**2+6*X1*X3+2*X2**2+15*X3**2-1)//
    (2*X2*(X1**2+24*X1*X3+105*X3**2+2)-SKEWNESS)//
    (24*(X1*X3+X2**2*(1+X1**2+28*X1*X3)+X3**2*
      (12+48*X1*X3+141*X2**2+225*X3**2))-KURTOSIS);
FINISH FUN;
START DERIV;
  J=((2*X1+6*X3)||(4*X2)||(6*X1+30*X3))//
    ((4*X2*(X1+12*X3))||(2*(X1**2+24*X1*X3+105*X3**2+2))
     ||(4*X2*(12*X1+105*X3)))//
    ((24*(X3+X2**2*(2*X1+28*X3)+48*X3**3))||
     (48*X2*(1+X1**2+28*X1*X3+141*X3**2))||
     (24*(X1+28*X1*X2**2+2*X3*(12+48*X1*X3+141*X2**2+225*X3**2)
 
     +X3**2*(48*X1+450*X3))));
FINISH DERIV;
DO;
NUM = NROW(SKEWKURT);
DO VAR=1 TO NUM;
  SKEWNESS=SKEWKURT[VAR,1];
  KURTOSIS=SKEWKURT[VAR,2];
  COEF={1.0, 0.0, 0.0};
  RUN NEWTON;
  COEF=COEF`;
  SK_KUR=SKEWKURT[VAR,];
  COMBINE=SK_KUR || COEF;
  IF VAR=1 THEN RESULT=COMBINE;
  ELSE IF VAR>1 THEN RESULT=RESULT // COMBINE;
END;
  PRINT "COEFFICEINTS OF B, C, D FOR FLEISHMAN'S POWER TRANSFORMATION";
  PRINT "Y = A + BX + CX^2 + DX^3";
  PRINT " A = -C";
  MATTRIB RESULT COLNAME=({SKEWNESS KURTOSIS B C D})
                 FORMAT=12.9;
  PRINT RESULT;
END;
 create fleishman from result[colname={SKEWNESS KURTOSIS B C D}];
   append from result;

QUIT;
 
%mend fleishman;
*kraj algoritma;

*koristenje algoritma za generiranje podataka;

*c dio;
title "Visina - generiranje 18 slučajnih brojeva";
%LET SEED = 6678;
%LET N = 18;

data skewkurt;
 	input skewness kurtosis;
 	datalines; *izracunato pomocu proc means;
 	0.8612172136 0.5187557448
;
run;
data meansig;
	input mean sig;
	datalines;
	165.43866667 17.078882316	
;
run;


%fleishman;

data RAND_VISINA;
	CALL STREAMINIT(&SEED);
	merge fleishman meansig;
	varid=_N_;
	a=-c;
	do i=1 to &N;
		x=RANNOR(0);
		x=a + b*x + c* x**2 + d*x**3;
		x=mean + sig* x;
	output;
 end;
run;

proc sort data=RAND_VISINA;
	by i;
proc transpose data=RAND_VISINA out=RAND_VISINA prefix=x;
	var x;
	id varid;
	by i;
run;
title2 "Procjenjene vrijednosti za generirane brojeve";
proc means data=RAND_VISINA mean std kurt skew;
	var x1;
run;

* d dio - ponavljamo sve za tezinu; 
title "Težina - generiranje 18 slučajnih brojeva";
data skewkurt;
 	input skewness kurtosis;
 	datalines; 
 	0.6647756095 -0.889452625
;
run;

data meansig;
	input mean sig;
	datalines;	
	51.470134207 13.160036455
;
run;

%fleishman;


data RAND_TEZINA;
	CALL STREAMINIT(&SEED);
	merge fleishman meansig;
	varid=_N_;
	a=-c;
	do i=1 to &N;
		x=RANNOR(0);
		x=a + b*x + c* x**2 + d*x**3;
		x=mean + sig* x;
	output;
 end;
run;

proc sort data=RAND_TEZINA;
	by i;
proc transpose data=RAND_TEZINA out=RAND_TEZINA prefix=x;
	var x;
	id varid;
	by i;
run;

title2 "Procjenjene vrijednosti za generirane brojeve";
proc means data=RAND_TEZINA mean std kurt skew;
	var x1;
run;

* e dio;
*prvo za težinu;
data skewkurt;
	input skewness kurtosis;
	datalines; 
	0.6647756095 -0.889452625
;
run;

data meansig;
	input mean sig;
	datalines;	
	51.470134207 13.160036455
	;
run;

%fleishman;
	
%macro my_code(seed); 

	data RAND_TEZINA;
		CALL STREAMINIT(&SEED);
		merge fleishman meansig;
		varid=_N_;
		a=-c;
		do i=1 to &N;
			x=RANNOR(0);
			x=a + b*x + c* x**2 + d*x**3;
			x=mean + sig* x;
		output;
 		end;
	run;

	proc sort data=RAND_TEZINA;
		by i;
	proc transpose data=RAND_TEZINA out=RAND_TEZINA prefix=x;
		var x;
		id varid;
		by i;
	run;
	
	proc means data=RAND_TEZINA mean std kurt skew;
	var x1;
	run;
	
%mend my_code;

title "Težina - različiti seed-ovi";
title2 "Seed 33456";
%my_code(33456);
%my_code(33456);
%my_code(33456);
%my_code(33456);
%my_code(33456);
title2 "Seed 4544";
%my_code(4544);
%my_code(4544);
%my_code(4544);
%my_code(4544);
%my_code(4544);
title2 "Seed 4236";
%my_code(4236);
%my_code(4236);
%my_code(4236);
%my_code(4236);
%my_code(4236);
title2 "Seed 56643";
%my_code(56643);
%my_code(56643);
%my_code(56643);
%my_code(56643);
%my_code(56643);


*Sada radimo istu stvar za visinu;
data skewkurt;
 	input skewness kurtosis;
 	datalines; *izracunato pomocu proc means;
 	0.8612172136 0.5187557448
;
run;
data meansig;
	input mean sig;
	datalines;
	165.43866667 17.078882316	
;
run;

%fleishman;

title "Visina - različiti seed-ovi";
title2 "Seed 33456";
%my_code(33456);
%my_code(33456);
%my_code(33456);
%my_code(33456);
%my_code(33456);
title2 "Seed 4544";
%my_code(4544);
%my_code(4544);
%my_code(4544);
%my_code(4544);
%my_code(4544);
title2 "Seed 4236";
%my_code(4236);
%my_code(4236);
%my_code(4236);
%my_code(4236);
%my_code(4236);
title2 "Seed 56643";
%my_code(56643);
%my_code(56643);
%my_code(56643);
%my_code(56643);
%my_code(56643);

*analogna promjena koda ide i za 100 puta;