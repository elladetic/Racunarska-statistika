libname lib "/home/u58223001/RS zadaće/Zadaća 8";  


proc univariate data=lib.normal2_rho_0_562 noprint;
histogram x y /normal(mu=est sigma=est);
run;

/*(a) i (b) dio*/

proc surveyselect data=lib.normal2_rho_0_562 out=outboot(keep=replicate x y) /* 2 */
seed=2234 /* 3 */
method=urs /* 4 */
samprate=1 /* 5 */
outhits /* 6 */
rep=500; /* 7 */
run;


proc corr data=outboot noprint 
out=outall(where=(_type_='CORR' & _name_='X')
                  rename=(Y=corr)
                  keep=y _TYPE_ _NAME_  );
 var x y;
by replicate;
run;

proc means data=outall mean std;
var corr;
run;

proc univariate data=outall noprint;
var corr;
output out=final pctlpts=5, 95 pctlpre=ci_ ;
run;
 
proc print data=final;
run;

/** correlation on the original data **/

proc corr noprint data=lib.normal2_rho_0_562
         out=corr(where=(_type_='CORR' & _name_='X')
                  rename=(Y=corr)
                  keep=Y _type_ _name_ );
         var X Y;
run;

data _NULL_;
 set corr end=last;
 if last then call symput('corr',put(corr,best10.));
run;

 
title1 "Nonparametric bootstrap estimate of corr.coef.";
   pattern v=solid c=green;                                                                                                               

   proc capability data=outall noprint;      
      histogram corr /  href=&corr chref=red lhref=1
                     
                       kernel(color = white fill) 
                       cfill        = blue 
                       pfill        = solid 
                       cframe       = gray 
                     
                       ; 
   inset mean std="Std Dev" / pos   = ne 
                              format= 6.3 
                              ctext = black 
                              cfill = white;
   inset p5 p95;
run; 


goptions reset=all; 

/*Parametarski*/

%let nboot=500;
%let n=15;
%let seed=2234;

/** correlation on the original data **/

proc corr noprint data=lib.normal2_rho_0_562
         out=corr(where=(_type_='CORR' & _name_='X')
                  rename=(Y=corr)
                  keep=Y _type_ _name_ );
         var X Y;
run;

data _NULL_;
 set corr end=last;
 if last then call symput('corr',put(corr,best10.));
run;

/** parametric bootstrap **/

DATA NORMAL2;
 DO REP = 1 TO &NBOOT;
  do i=1 to &n;
  X1 = NORMAL (&SEED);	
  X2 = NORMAL (&SEED);	
  Xsim = X1;
  Ysim = &CORR * X1 + SQRT(1 - &CORR**2)* X2;
  OUTPUT;
 end;
 END;
 DROP X1 X2 i;
RUN; 

proc corr noprint data=normal2
         out=pbootdist(where=(_type_='CORR' & _name_='Xsim')
                  rename=(Ysim=bootcorr)
                  keep=Ysim _TYPE_ _NAME_ rep);
         var Xsim Ysim;
		 by rep;
run;


proc means data=pbootdist mean std;
var bootcorr;
run;

proc univariate data=pbootdist noprint;
var bootcorr;
output out=final pctlpts=5, 95 pctlpre=ci_ ;
run;
 
proc print data=final;
run;
   
title1 "Parametric bootstrap estimate of corr.coef.";
   pattern v=solid c=green;                                                                                                               

   proc capability data=pbootdist noprint;      
      histogram bootcorr /  href=&corr chref=red lhref=1
                     
                       kernel(color = white fill) 
                       cfill        = blue 
                       pfill        = solid 
                       cframe       = gray 
                     
                       ; 
   inset mean std="Std Dev" / pos   = ne 
                              format= 6.3 
                              ctext = black 
                              cfill = white;
   inset p5 p95;
run; 


goptions reset=all; 

/*neparametarski: Bootstrap procjena sredine korelacijskog koeficijenta iznosi 0.5317221,
a bootstrap procjena standardne pogreške iznosi 0.2125377. 90% p.i.  za korelacijski 
koeficijent iznosi [0.080824, 0.82359].*/

/*-parametarski: Bootstrap procjena sredine korelacijskog koeficijenta iznosi 0.5519069,
a bootstrap procjena standardne pogreške iznosi 0.1852439. 90% p.i.  za korelacijski 
koeficijent iznosi [0.18691, 0.80647].*/
