*generiranje dobi žena u RH;

LIBNAME dob '/home/u58223001/RS ZADAĆE/Zadaća 2'; *ova putanje je dolje na programu;
DATA dob_zena;
   set dob.dob_zenahr_18_30 (keep=Starost dprob);
RUN;

*definicija mrantbl;
%macro mrantbl(dat,catvar,pvar,rep,seed);

DATA _NULL_;
 set &dat end=end;
 if end then call symput("ncat",left(put(_N_,3.))); 
run;

DATA TEMP(KEEP=&catvar);
     SET &dat END=ENDD; 

     ARRAY &catvar.S(&ncat) $5 &catvar.1-&catvar&ncat;
     ARRAY PROB(&ncat) PROB1-PROB&ncat;
     RETAIN &catvar.1-&catvar&ncat PROB1-PROB&ncat;
     &catvar.S(_N_)=&catvar; 
     PROB(_N_)=&pvar;
	
    
     
     IF ENDD THEN DO;
        DO I=1 TO &rep;
        
           &catvar=&catvar.S(RANTBL(&seed,OF PROB(*)));
           OUTPUT;
        END;
        END;

PROC FREQ DATA=TEMP;
     TABLE &catvar / NOPRINT OUT=FREQHIST(RENAME=(PERCENT=RNDPNT)
                                 KEEP=&catvar PERCENT COUNT);
     RUN; 

PROC SORT DATA=&dat;
     BY &catvar;
DATA BOTH;
     MERGE &dat FREQHIST; 
     BY &catvar;
     SAMPLE='Theoretical';
     FRQ=ROUND(&rep*&pvar);
     OUTPUT;
     SAMPLE='Random';
     FRQ=COUNT;
     OUTPUT;
     RUN;

PROC FREQ DATA=BOTH;
     TABLE SAMPLE*&catvar / CHISQ;
     WEIGHT FRQ;
     RUN;
%mend mrantbl;

*poziv  mrantbl za  10000;
title 'Broj replikacija 10000';
%mrantbl(dat=dob_zena, catvar=Starost, pvar=dprob, rep=10000, seed=123)

/* usporedba stupčastog dijagrama s teorijskim */
PROC GCHART data=both;
vbar starost/ 	discrete
				group=sample
				patternid=group
				sumvar=frq;
RUN;
QUIT;

*poziv  mrantbl za  1000;
title 'Broj replikacija 1000';
%mrantbl(dat=dob_zena, catvar=Starost, pvar=dprob, rep=1000, seed=123)

/* usporedba stupčastog dijagrama s teorijskim */
PROC GCHART data=both;
vbar starost/ 	discrete
				group=sample
				patternid=group
				sumvar=frq;
RUN;
QUIT;



