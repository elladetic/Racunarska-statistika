title "Zadatak 5.1";

%let N = 50;
%let NumSamples = 1000;

/* 1. Simulate obs from N(0,1) */
data Normal(keep=SampleID x);
	call streaminit(0);
	do SampleID = 1 to &NumSamples;
   		do i = 1 to &N;
      		x = rand("Normal");
      		output;
		end; 		
	end;
run;

/* 2. Compute statistics for each sample */
proc means data=Normal noprint;
	by SampleID;
	var x;
	output out=OutStats mean=SampleMean lclm=Lower uclm=Upper;
run;

ods graphics / width=6.5in height=4in;
proc sgplot data=OutStats(obs=100);
	scatter x=SampleID y=SampleMean;
	highlow x=SampleID low=Lower high=Upper / legendlabel="95% CI";
	refline 0 / axis=y;
	yaxis display=(nolabel);
run;


data OutStats;  
	set OutStats;
	P = (Lower<0 & Upper>0);   *jer mora sadržavati 0;      
run;


proc freq data=OutStats;
	tables P / nocum;
run;

*broj uzorka = 10000, vrijednost P varira između 94 i 95.50 ->
* 94.92, 95.13, 95.02, 94.86....
*broj uzorka = 1000, P vrijednost ponekad padne ispod 95% -> 
zaključak je da je range veći za manji broj uzorka;




title "Zadatak 5.3";
%let NumSamples = 10000;

data Exp(keep=SampleID x);
call streaminit(123);
do SampleID=1 to &NumSamples;
	do i=1 to &N;
		x=rand("Expo")-1;
		output;
	end;
end;

proc means data=Exp noprint;
	by SampleID;
	var x;
	output out=OutStatsExp mean=SampleMean lclm=Lower uclm=Upper;
run;


/* how many CIs include parameter? */
data OutStatsExp; 
	set OutStatsExp;
	P = (Lower<0 & Upper>0);
run;

proc freq data=OutStatsExp;
	tables P  / binomial alpha=.05 binomial(level=2);
run;

*otputom koda smo potvrdili da 0.95 nije sadržan u intervalu pouzdanosti;
