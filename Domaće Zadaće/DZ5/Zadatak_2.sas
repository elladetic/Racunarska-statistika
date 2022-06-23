/* bias/pristranost koeficijenta spljostenosti (kurtosis) za male uzorke */
title "Veličina uzorka - 20";
%let N = 20; *velicina uzorka;

%let NumSamples = 2000; *broj replikacija;

data SimSK(drop=i);
	call streaminit(3456);
	do SampleID=1 to &NumSamples;
		do i=1 to &N;
			Normal=rand("Normal");
			t=rand("t", 5);
			Exponential=rand("Expo");
			LogNormal=exp(rand("Normal", 0, 0.503));
			output;
		end;
	end;
run;

proc means data=SimSK noprint;
	by SampleID; 
	var Normal t Exponential LogNormal;
	output out=Moments(drop=_type_ _freq_) Kurtosis=; *sada radim sa spljišenosti, ne zakrivljenost;
run;


proc transpose data=Moments out=Long(rename=(col1=Kurtosis));
	by SampleID;
run;

proc sgplot data=Long;
	title "Kurtosis Bias in Small Samples: N=&N";
	label _Name_="Distribution";
	vbox Kurtosis / category=_Name_ meanattrs=(symbol=Diamond);
	refline 0 1.764 2 / axis=y;
	yaxis max=10;
	xaxis discreteorder=DATA;
run;


title "Veličina uzorka - 100";
%let N = 100; *velicina uzorka;

%let NumSamples = 2000; *broj replikacija;


data SimSK(drop=i);
	call streaminit(3456);

	do SampleID=1 to &NumSamples;
		do i=1 to &N;
			Normal=rand("Normal");
			t=rand("t", 5);
			Exponential=rand("Expo");
			LogNormal=exp(rand("Normal", 0, 0.503));
			output;
		end;
	end;
run;

proc means data=SimSK noprint;
	by SampleID; 
	var Normal t Exponential LogNormal;
	output out=Moments(drop=_type_ _freq_) Kurtosis=;;
run;


proc transpose data=Moments out=Long(rename=(col1=Kurtosis));
	by SampleID;
run;

proc sgplot data=Long;
	title "Kurtosis Bias in Small Samples: N=&N";
	label _Name_="Distribution";
	vbox Kurtosis / category=_Name_ meanattrs=(symbol=Diamond);
	refline 0 1.764 2 / axis=y;
	yaxis max=10;
	xaxis discreteorder=DATA;
run;

*ovdje vidimo da je samo koeficijent normalne nepristran;
*povećanjem uzorka stvari su gore za sve distribucije osim normalne, kvadratić još više udaljava
od horizontalne linije -> nepristranost na malom uzorku se cini da nije zbog velicine!