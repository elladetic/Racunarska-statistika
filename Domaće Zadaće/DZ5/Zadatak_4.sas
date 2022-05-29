title "Zadatak 5.6";
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
			x1=rand("Normal");
			x2=x1;
			output;
		end;
		c=2;
		do i=1 to &n2;
			x1=rand("Normal");
			x2=rand("Normal", 0, 2);
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
	var x1-x2; 		
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


title2 "Simulacija - N(0,5)";
data EV(drop=i);
	label x1="Normal data, same variance" x2="Normal data, different variance";
	call streaminit(321);

	do SampleID=1 to &NumSamples;
		c=1;

		do i=1 to &n1;
			x1=rand("Normal");
			x2=x1;
			output;
		end;
		c=2;

		do i=1 to &n2;
			x1=rand("Normal");
			x2=rand("Normal", 0, 5);
			output;
		end;
	end;
run;

%ODSOff;

proc ttest data=EV;
	by SampleID;
	class c; 		
	var x1-x2; 		
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


title2 "Simulacija -  N(0,100)";
data EV(drop=i);
	label x1="Normal data, same variance" x2="Normal data, different variance";
	call streaminit(321);

	do SampleID=1 to &NumSamples;
		c=1;

		do i=1 to &n1;
			x1=rand("Normal");
			x2=x1;
			output;
		end;
		c=2;

		do i=1 to &n2;
			x1=rand("Normal");
			x2=rand("Normal", 0, 100);
			output;
		end;
	end;
run;

%ODSOff;

proc ttest data=EV;
	by SampleID;
	class c; 		
	var x1-x2; 		
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


title "Zadatak 5.7";

title2 "Simulacija -  Različit broj opservacija";
%let n1 = 20;
%let n2 = 10;
%let NumSamples = 10000;
data EV(drop=i);
	label x1="Normal data, same variance" x2="Normal data, different variance";
	call streaminit(321);

	do SampleID=1 to &NumSamples;
		c=1;

		do i=1 to &n1;
			x1=rand("Normal");
			x2=x1;
			output;
		end;
		c=2;

		do i=1 to &n2;
			x1=rand("Normal");
			x2=rand("Normal", 0, 10);
			output;
		end;
	end;
run;

%ODSOff;

proc ttest data=EV;
	by SampleID;
	class c; 		
	var x1-x2; 		
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

*iz rezultata vidimo da povecavanje varijance utjece na jačinu t-testa, odnosno, postotak 
odbačenih nultih hipoteza se povećava većom varijancom(varijabla 1 kod RejetedH0);

title2 "Simulacija -  Jednak broj opservacija";
%let n1 = 15;
%let n2 = 15;
%let NumSamples = 10000;
data EV(drop=i);
	label x1="Normal data, same variance" x2="Normal data, different variance";
	call streaminit(321);

	do SampleID=1 to &NumSamples;
		c=1;

		do i=1 to &n1;
			x1=rand("Normal");
			x2=x1;
			output;
		end;
		c=2;

		do i=1 to &n2;
			x1=rand("Normal");
			x2=rand("Normal", 0, 10);
			output;
		end;
	end;
run;

%ODSOff;

proc ttest data=EV;
	by SampleID;
	class c; 		
	var x1-x2; 		
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

*vidimo da je test osjetljiv na uzorke različitih duljina, 
jači test je ako su uzorci jednakih duljina;