title "Zadatak 5.8";
%let n1 = 10;
%let n2 = 10;
%let NumSamples = 10000;

title2 "Simulacija N(0,2)";
data EV(drop=i);
	label x1="Normal data, same variance" x2="Normal data, different variance";
	call streaminit(321);
	do SampleID=1 to &NumSamples;
		c=1;
		do i=1 to &n1;
			x3=rand("Exponential");
			x4=rand("Normal", 10);
			x5 = rand("Gamma", 10);
			output;
		end;
		c=2;
		do i=1 to &n2;
			x3=rand("Exponential");
			x4=10*rand("Exponential");
			x5 = Rand("Exponential", 10);
			output;
		end;
	end;
run;

%macro ODSOn;
	ods graphics on;
	ods exclude none;
	ods results;
%mend;

%macro ODSOff;
	ods graphics off;
	ods exclude all;
	ods noresults;
%mend;

/* 2. Compute statistics */
%ODSOff;
proc ttest data=EV;
	by SampleID;
	class c; 		
	var x3-x5; 		
	ods output ttests=TTests(where=(method="Pooled"));
run;

%ODSOn;


data Results;
	set TTests;
	RejectH0=(Probt <=0.05);	
run;

proc sort data=Results;
	by Variable;
run;

proc freq data=Results;
            by Variable;
            tables RejectH0 / nocum;
run;

* vjerojatnost da odbacimo H_0, ako su uzorci iz gamma(10) i exp(10) razdiobe, je 8.76%;



