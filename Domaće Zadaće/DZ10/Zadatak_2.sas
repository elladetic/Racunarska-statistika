%let seed = 575867;
%let rep = 1000;
%let h = 0.5;

/*
---------------------------------------------------------------------
A DIO 
--------------------------------------------------------------------- 
*/

data generate;
	call streaminit(&seed); 
	do M = 1 to &rep;
		x = RAND("Uniform", 0, 1); 
  		output;
 	end;
run;

data sums; 
	set generate;
	x = x**2 / PDF('UNIFORM', x, 0,1); *f(x)=x**2;
run; 

data cumulative_sums;
	set sums;
	retain sum_cum;	
	if M = 1 then sum_cum = x;
	else sum_cum = (sum_cum + x);					
run; 

data cumulative;
	set cumulative_sums;
	mean_cum = sum_cum / M;
	error_cum = abs(0.5 - mean_cum);
	keep M mean_cum error_cum;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.CUMULATIVE;
	vline M / response=mean_cum lineattrs=(pattern=mediumdash color=blue) 
		stat=mean;
	xaxis label="Broj replikacija" values=(0 to 1000 by 100);
	yaxis grid label="Kumulativni prosjek";
run;

ods graphics / reset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.CUMULATIVE;
	vline M / response=error_cum lineattrs=(pattern=mediumdash color=CXff2727) 
		stat=mean;
	xaxis label="Broj replikacija" values=(0 to 1000 by 100);
	yaxis grid label="Kumulativna greška";
run;

ods graphics / reset;