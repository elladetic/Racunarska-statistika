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


*a dio;
data body_mass_index;
	input bmi @@;
 	bmi_diff=bmi-31.9;
 	cards;
 	32.1 33.6 31.3 31.8 28.1 34.5 35.1 34.9 29.9 49.2 36.2 30.7 38.4 45.6 48.6 26.5
;
run;

*b dio;
proc means data=body_mass_index noprint;
	var bmi_diff;
	output out=skewkurt(drop=_type_ _freq_) skewness=skewness kurtosis=kurtosis;
	output out=meansig(drop=_type_ _freq_) mean=mean std=sig;
run;

*Analysis Variable : bmi_diff
Skewness 	Kurtosis
1.0523009 	0.2471305;

*c i d dio;

%LET SEED =54957;		
%LET NREPtot=10000;	
%let nn=10 16 20 30 50 100 200;
%let nrep=&nreptot; 

%LET K=0.5;
%LET beta=1;
%let mu=%sysevalf(&k/&beta);

ods graphics off;
proc datasets library=work;
 	delete tall;
run; quit;
ods graphics on;

data skewkurt;
 	input skewness kurtosis;
 	datalines; *izracunato pomocu proc means;
 	1.0523009 0.2471304846
;
run;
data meansig;
	input mean sig;
	datalines;
	0 1	
;
run;

%fleishman; 

%macro nsize;
%let kk=1; 
%let n=%scan(&nn,&kk); 
%do %while(&n NE); 

data raw;
 	N=&N;
	CALL STREAMINIT(&SEED);
	merge fleishman meansig;
	varid=_N_;
	a=-c;
	do rep=1 to &nrep;
		do i=1 to &n;
			x=rand("normal");
			x=a+b*x+c*x**2+d*x**3;
			x=mean+sig*x;
			xt=x - mean;
		output;
		end;
	end;
 	drop i B C D mean sig varid a SKEWNESS KURTOSIS;
 	label rep='repetition';
run;
                                                                                      
proc means data=raw noprint;                                                                                              
  var xt;                                                                                                         
  by rep;                                                                                                        
  output out=t mean=mean stderr=stderr t=t; 
  id n;
run; 

proc append base=tall data=t;
run;
   %let kk=%eval(&kk+1); 
   %let n=%scan(&nn,&kk); 
%end; 
%mend nsize;

%nsize;

data tall;
 set tall;

   t_crit_01=TINV(0.01,n-1);
   fraction_crit_01_left=(t le t_crit_01);
   fraction_crit_01_right=(t ge -t_crit_01);

   t_crit_02=TINV(0.02,n-1);
   fraction_crit_02_left=(t le t_crit_02);
   fraction_crit_02_right=(t ge -t_crit_02);

   t_crit_05=TINV(0.05,n-1);
   fraction_crit_05_left=(t le t_crit_05);
   fraction_crit_05_right=(t ge -t_crit_05);
   
   t_crit_1=TINV(0.1,n-1);
   fraction_crit_1_left=(t le t_crit_1);
   fraction_crit_1_right=(t ge -t_crit_1);
run;

proc means data=tall nway noprint; *ovo su p vrijednosti -> dvostrana je zbroj lijevo i desno!;
 var fraction_crit_01_left fraction_crit_01_right fraction_crit_02_left fraction_crit_02_right
      fraction_crit_05_left fraction_crit_05_right fraction_crit_1_left fraction_crit_1_right;
 output out=fraction mean=; 
 class n;
run;


*na kraju, usporedba s ttest - dio;
*dvostrana, pvalue je 0.0592;
proc ttest data = body_mass_index alpha= 0.1 side=2;
	var bmi_diff;
run;

*jednostrana, pvalue je 0.0296;
proc ttest data = body_mass_index alpha= 0.1 side=U;
	var bmi_diff;
run;


proc print data = fraction(drop=_TYPE_ _FREQ_);
run;

ods select none;

proc ttest data=body_mass_index;
	var bmi_diff;
	ods output ttests=ttValues(keep=tvalue probt);
run;

ods select all;

data mc_p(keep=t N_sig1 N_sig2);
	set tall;
	n_sig1=(abs(t) ge 2.04);
	n_sig2=(t ge 2.04);
run;

proc means data=mc_p noprint;
	var n_sig1 n_sig2;
	output out=p_sig sum=;
run;

data p_sig_mc;
	set p_sig;
	p_sig_jednostrani=(n_sig2+1)/(_freq_+1);
	p_sig_dvostrani=(n_sig1+1)/(_freq_+1);
run;

proc sql;
	select p_sig_jednostrani "mc_p_jednostrani", p_sig_dvostrani "mc_p_dvostrani", 
		probt/2 "ttest_p_jednostrani", probt "ttest_p_dvostrani" from p_sig_mc inner join 
		ttvalues on 1=1;
quit;


