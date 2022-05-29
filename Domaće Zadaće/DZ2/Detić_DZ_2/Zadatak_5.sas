data TLAK_REAL;
	input SKTprije SKTposlije @@;
	datalines;
	120 127   128 130   130 131   118 127
	140 132   128 125   140 141   135 137
	126 118   130 132   130 129   127 120
	122 121   141 125  
	;
run;

*a dio;
proc means data = TLAK_REAL mean; * da znamo postaviti H_1;
run;
*H_0 = nije došlo do smanjena sistoličkog tlaka, odnosno mi_prije = mi_poslije;
*H_1 = došlo je do smanjena sistoličkog tlaka, odnosno mi_prije > mi_poslije;

proc ttest data=TLAK_REAL sides=2 alpha=0.05 h0=0;
	title "Paired sample t-test example";
	paired SKTprije * SKTposlije;
   run;
*velik p value, ne odbacujemo H_0;

*b dio - generiranje bivarijantne distribucije; 
%let seed= 5678;
proc corr data=tlak_real outp=parametri(drop= _name_);
run;  *u parametri su nam spremljeni svi uzorački podaci;

data ro; *zelim razdvojiti te podatke jer nemogu dohvatiti i-ti element retka;
	set parametri;
	where _type_='CORR';
	CALL SYMPUT ('rho',SKTprije);
run;

data sredine;
	set parametri;
	where _type_='MEAN';
	CALL SYMPUT ('mprije',SKTprije);
	CALL SYMPUT ('mposlije',SKTposlije);
run;

data stdevijacije;
	set parametri;
	where _type_='STD';
	CALL SYMPUT ('sdprije',SKTprije);
	CALL SYMPUT ('sdposlije',SKTposlije);
run;

%PUT 'rho:' &rho;
%PUT 'mposlije:' &mposlije;

data TLAK_generate;
  DO REP=1 to 100;
  	X1 = NORMAL(&SEED);
	X2 = NORMAL(&SEED);
	TLAK_prije_generate = X1;
	TLAK_prije_generate= &sdprije * TLAK_prije_generate+&mprije;
	TLAK_poslije_generate = &RHO * X1 + SQRT(1 - &RHO**2)* X2;
	TLAK_poslije_generate = &sdposlije*TLAK_poslije_generate+&mposlije;
	output;
  END;
  DROP X1 X2;
run;

proc corr data = TLAK_generate;
	var TLAK_prije_generate TLAK_poslije_generate;
run;

/* (c) dio */
data generirani_c;
  DO REP=1 to 100;
  DO I=1 to 14;
    X1 = NORMAL(&SEED);
	X2 = NORMAL(&SEED);
	X = X1;
	X=&sdprije*X+&mprije;
	Y = &RHO * X1 + SQRT(1 - &RHO**2)* X2;
	Y=&sdposlije*Y+&mposlije;
	output;
  END;
    drop X1 X2;
  END;
run;

/*%odsoff;*/
ods graphics off;
ods exclude all;
ods results;
ods output ttests=ttests (keep = tValue);
proc ttest data=generirani_c;
   paired X*Y;
    by rep;
run; 
ods graphics on;
ods exclude none;
ods results;
/*%ODSOn;*/

proc univariate data= ttests;
	var tValue;
run;

/* (d) dio */


ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.TTESTS;
	histogram tValue / nbins=18;
	density tValue / type=Kernel;
	xaxis min=-3 max=8;
	yaxis grid;
run;

ods graphics / reset;
   
 
%let DOF=13;                           
data t_pdf;
   do x=-3 to 8 by 0.01;
      pdf_t = pdf('t', x, &DOF);      
      output;
   end;
run;
proc sgplot data=t_pdf noautolegend;
   series x=x y=pdf_t;
run;

/*nase tValue vrijednosti donekle slici t(13) distribuciji, ali nije bas simetricna oko 0*/
