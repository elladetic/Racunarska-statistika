%LET SEED =123578;		%LET K=0.5; 
%LET NREPtot=100000;	%LET beta=1; 
%let nn=10 20 30 50 100 200;
 %let nrep=10000;

%let mu=%sysevalf(&k/&beta); 
%let gopt=hby=0; 

proc datasets library=work;
 delete tall;
run; quit;

%macro nsize;

%let kk=1; 
%let n=%scan(&nn,&kk); 
%do %while(&n NE); 

DATA RAW;
 N=&N;
 CALL STREAMINIT(&SEED);
 DO REP = 1 TO &NREP;
 DO I=1 to &N;
  X = RAND ("GAMMA",&k);
  XT = X - &mu;
  OUTPUT;
 END;
 END;
 label rep='repetition';
RUN;
                                                                                      
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
 
 

title1 "t values from GAMMA(&k,&beta), n=&nn";


   proc boxplot data=tall ;  
      plot t*n /   cframe   = vligb  BOXSTYLE=SCHEMATIC                                                                                           
                     cboxes   = dagr BOXCONNECT  CCONNECT=blue                                                                                                 
                     cboxfill = ywh vref=0 cvref=red 
                      IDCOLOR= black  IDSYMBOL=square;      
   run; quit;  


filename boxplott clear;  
    goptions reset=all; 
title;

 proc means data=tall mean std stderr skewness kurtosis maxdec=3;
   var t;
   class n;
 run;
ods html close; 

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=WORK.TALL out=Work.SortTempTableSorted;
	by N;
run;


proc univariate data=Work.SortTempTableSorted;
	ods select Histogram;
	var mean t;
	histogram mean t;
	by N;
run;

proc univariate data=Work.SortTempTableSorted;
	ods select QQPlot;
	var mean t;

	/* Checking for Normality */
	qqplot mean t / normal(mu=est sigma=est);
	inset mean std n / position=nw;
	by N;
run;

proc delete data=Work.SortTempTableSorted;
run;

/*Sto je N veci, to razdioba od mean i t sve vise lici na normalnu razdiobu sto je u skladu s centralnim granicnim teoremom*/
/*ocekivane vrijednosti su: N		10		20		30		50		100		200
							mean = 	0.5		0.5		0.5		0.5		0.5		0.5
							std = 	0.2236	0.1581	0.1291	0.1		0.0707	0.05 */
/*Iz tablice vidimo da su sve vrijednosti jako blizu ocekivanih vrijednosti i za mean i za std*/


%LET SEED =123578;		%LET K=0.5;
%LET NREPtot=100000;	%LET beta=1; 
%let nn=10 20 30 50 100 200;
 %let nrep=10000;

%let mu=0.5; 
%let gopt=hby=0;

proc datasets library=work;
 delete tall;
run; quit;

%macro nsize;

%let kk=1; 
%let n=%scan(&nn,&kk); 
%do %while(&n NE); 

DATA RAW;
 N=&N;
 CALL STREAMINIT(&SEED);
 DO REP = 1 TO &NREP;
 DO I=1 to &N;
  X = RAND ("UNIFORM");
  XT = X - &mu;
  OUTPUT;
 END;
 END;
 label rep='repetition';
RUN;
                                                                                      
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

 

title1 "t values from UNIFORM(0,1), n=&nn";


   proc boxplot data=tall ;  
      plot t*n /   cframe   = vligb  BOXSTYLE=SCHEMATIC                                                                                           
                     cboxes   = dagr BOXCONNECT  CCONNECT=blue                                                                                                 
                     cboxfill = ywh vref=0 cvref=red 
                      IDCOLOR= black  IDSYMBOL=square;      
   run; quit;  


filename boxplott clear;  
    goptions reset=all; 
title;


 proc means data=tall mean std stderr skewness kurtosis maxdec=3;
   var t;
   class n;
 run;
ods html close; 


ods noproctitle;
ods graphics / imagemap=on;

proc sort data=WORK.TALL out=Work.SortTempTableSorted;
	by N;
run;


proc univariate data=Work.SortTempTableSorted;
	ods select Histogram;
	var mean t;
	histogram mean t;
	by N;
run;

proc univariate data=Work.SortTempTableSorted;
	ods select QQPlot;
	var mean t;


	qqplot mean t / normal(mu=est sigma=est);
	inset mean std n / position=nw;
	by N;
run;

proc delete data=Work.SortTempTableSorted;
run;

/*Rezultati su jos bolji nego za gama razdiobu*/