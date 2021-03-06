
*******  Program for ANOVA Example: Assessing the Effect of Data Non-Normality on the Type I Error Rate in ANOVA  *************;
 
******* Note: RUN autoexec.sas program  ******************
*******       RUN fleishman macro       ******************;

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



data skewkurt;
 input skewness kurtosis;
 datalines;
 2.5  6
;
run;

%fleishman; 

                 
 

data fleishman;
 set fleishman;
 aa=2; output;
 aa=1; b=1; c=0; d=0; SKEWNESS=0; KURTOSIS=0; output;
run;



%MACRO ANOVA;

%DO A=1 %TO 2;        * A=1: normal data,  A=2: non-normal data;
%DO B=1 %TO 2;        * B=1: equal variance,  B=2: unequal variance;


%LET ALPHA=0.05;   * nominal Type I error rate;
 



                   * means and variances of 3 groups
	                 A=1: normal data, A=2:non-normal data
                     B=1: equal variances, B=2: unequal;
 
  * generate data for group 1;

data group1;
 merge fleishman(where=(aa=&a)) meanvar(where=(a=&a and b=&b and group=1));

 a=-c;
 DO REP=1 TO 1000;   * 1,000 replications in each cell;

 do i=1 to n;
    x=RANNOR(0);
	x=a + b*x + c* x**2 + d*x**3;
	x=mean + sqrt(var)* x;
	output;
 end;
 end;
run;

 * generate data for group 2;

data group2;
 merge fleishman(where=(aa=&a)) meanvar(where=(a=&a and b=&b and group=2));

 a=-c;
 DO REP=1 TO 1000;   * 1,000 replications in each cell;

 do i=1 to n;
    x=RANNOR(0);
	x=a + b*x + c* x**2 + d*x**3;
	x=mean + sqrt(var)* x;
	output;
 end;
 end;
run;

 * generate data for group 3;

data group3;
 merge fleishman(where=(aa=&a)) meanvar(where=(a=&a and b=&b and group=3));

 a=-c;
 DO REP=1 TO 1000;   * 1,000 replications in each cell;

 do i=1 to n;
    x=RANNOR(0);
	x=a + b*x + c* x**2 + d*x**3;
	x=mean + sqrt(var)* x;
	output;
 end;
 end;
run;

 
                  * combine 3 groups data, vertical concatenation;

data dataall;
 set group1 group2 group3;
 run;

proc sort data=dataall;
 by rep group;
 run;
 
 

                   * run ANOVA analysis, and output ANOVA results
                     to a SAS working data 'ANOVAOUT';

PROC ANOVA DATA=DATAALL NOPRINT OUTSTAT=ANOVAOUT;
  CLASS GROUP;
  MODEL X=GROUP;
  by rep;
RUN;
                    * use 'ANOVAOUT' data;
                    * extract relevant ANOVA results;

DATA AA; SET ANOVAOUT;
  IF _TYPE_='ANOVA';
  DF_MOD=DF; SS_MOD=SS;

                    * add a variable indicating statistical significance;
  IF PROB<&ALPHA THEN SIG='YES';
     ELSE SIG=' NO';

  KEEP DF_MOD SS_MOD F PROB SIG REP;     * keep relevant variables;

                    * extract error df, error sum-of-squares;

DATA BB; SET ANOVAOUT;
  IF _TYPE_='ERROR';
  DF_ERR=DF; SS_ERR=SS;
  KEEP DF_ERR SS_ERR REP;

                   * merge two data sets, add study design information;
DATA AB; MERGE AA BB;
by rep;
  IF &A=1 THEN NORMAL='YES';
     ELSE IF &A=2 THEN NORMAL=' NO';
  IF &B=1 THEN EQ_VAR='YES';
     ELSE IF &B=2 THEN EQ_VAR=' NO';
                    * append each replication results to a permanent SAS data;
PROC APPEND BASE=&resultsdataset;
RUN;

proc datasets library=work;
 delete dataall group1 group2 group3 aa bb ab;
 run; quit;

%END;         * close B do loop;
%END;         * close A do loop;

%MEND ANOVA;  * macro 'ANOVA';




/* desired mean, var, n for each group (=1,2,3) and each A and B */
/* A=1: normal data,  A=2: non-normal data                       */
/* B=1: equal variance,  B=2: unequal variance                   */

/*** FIRST RUN: Equal sample size per group ***/

%let resultsdataset=work.ANOVA_same_n_30;  *Name of the dataset with the results of the MC experiment;
data meanvar;
 input A B group mean var n;
 datalines;
 1 1 1 50 20 30
 1 1 2 50 20 30
 1 1 3 50 20 30
 1 2 1 50 10 30
 1 2 2 50 20 30
 1 2 3 50 30 30
 2 1 1 50 20 30
 2 1 2 50 20 30
 2 1 3 50 20 30
 2 2 1 50 10 30
 2 2 2 50 20 30
 2 2 3 50 30 30
;
run;

%ANOVA;       * run macro 'ANOVA';


    * obtain descriptive statistics for the simulation results;
DATA A; SET &resultsdataset;
PROC SORT; BY NORMAL EQ_VAR;
PROC FREQ; BY NORMAL EQ_VAR;
  TABLES SIG;
RUN;
******************************************************************************************;

/*** SECOND RUN: Unequal sample size per group and sample size directly proportional to variance ***/


%let resultsdataset=work.ANOVA_propvar_different_n_30;  *Name of the dataset with the results of the MC experiment;

data meanvar;
 input A B group mean var n;
 datalines;
 1 1 1 50 20 10
 1 1 2 50 20 30
 1 1 3 50 20 50
 1 2 1 50 10 10
 1 2 2 50 20 30
 1 2 3 50 30 50
 2 1 1 50 20 10
 2 1 2 50 20 30
 2 1 3 50 20 50
 2 2 1 50 10 10
 2 2 2 50 20 30
 2 2 3 50 30 50
;
run;

%ANOVA;       * run macro 'ANOVA';

              * obtain descriptive statistics for the simulation results;
DATA A; SET &resultsdataset;
PROC SORT; BY NORMAL EQ_VAR;
PROC FREQ; BY NORMAL EQ_VAR;
  TABLES SIG;
RUN;
******************************************************************;
/* THIRD RUN: Unequal sample size per group and sample size indirectly proportional to variance*/

%let resultsdataset=work.ANOVA_inpropvar_different_n_30;  *Name of the dataset with the results of the MC experiment;

data meanvar;
 input A B group mean var n;
 datalines;
 1 1 1 50 20 50
 1 1 2 50 20 30
 1 1 3 50 20 10
 1 2 1 50 10 50
 1 2 2 50 20 30
 1 2 3 50 30 10
 2 1 1 50 20 50
 2 1 2 50 20 30
 2 1 3 50 20 10
 2 2 1 50 10 50
 2 2 2 50 20 30
 2 2 3 50 30 10
;
run;

%ANOVA;       * run macro 'ANOVA';

              * obtain descriptive statistics for the simulation results;
DATA A; SET &resultsdataset;
PROC SORT; BY NORMAL EQ_VAR;
PROC FREQ; BY NORMAL EQ_VAR;
  TABLES SIG;
RUN;
******************************************************************;
																								normalnost
/*																								
------------------------------------------------------------------------------------|		DA		|		NE
						|DA												|			|DA		5.43	|		4.50
						|												|			|NE		5.43	|		4.87
------------------------|-----------------------------------------------|-----------|-----------------------------
						|												|jednakost	|DA		4.45	|		4.20
jednak broj podataka	|NE, broj podataka indirektno proporcionalan	|varijanci	|				|
po grupama				|	varijancama									|			|NE		12.90	|		11.60
------------------------|-----------------------------------------------|-----------|-----------------------------
						|NE, broj podataka direktno proporcionalan		|			|DA		6.10	|		5.33
						|	varijancama									|			|				|
						|												|			|NE		5.47	|		5.87
--------------------------------------------------------------------------------------------------------------------

Vidimo da je ANOVA test jako osjetljiv ako nemamo jednak broj podataka po grupama i ako je broj podataka indirektno proporcionalan varijancama gdje varijance nisu jednake
Dakle ako nisu zadovoljene pretpostavke jednakosti varijanci i jednak broj podatak po grupama, onda su rezultati jako losi, tj. vjerojatnost pogreske prve vrste jako odstupa od ocekivane vrijednosti od 0.05 = 5%

Test cak daje dobre rezultate na odstupanje od normalnosti

Sto se tice nejednakosti varijanci vidimo da i dalje imamo dobre rezultate osim u slucaju kada imamo nejednake grupe kao sto smo komentirali malo prije*/

