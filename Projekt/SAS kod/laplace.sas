/*macro ODSOff i ODSOn*/
%macro ODSOff;
ods graphics off;
ods exclude all;
ods noresults;
%mend;
%macro ODSOn;
ods graphics on;
ods exclude none;
ods results;
%mend;


libname lib "/home/u58252441/sasuser.v94/RS/Projekt";
%include "/home/u58252441/sasuser.v94/RS/Projekt/power_t_test.sas";



%let seed = 15;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;

title1 "Laplace distribucija";
%let distribution = "L";

title2 height=7pt "Veličina uzorka  je 10" ;
%power_t_test(10, &n_rep, &seed, &distribution, &mu, &sigma); 

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.PVALUES out=_SeriesPlotTaskData;
	by mu_0;
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_01 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.01)";
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_05 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.05)";
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
	
title2 height=7pt "Veličina uzorka  je 15";
%power_t_test(15, &n_rep, &seed, &distribution, &mu, &sigma);

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.PVALUES out=_SeriesPlotTaskData;
	by mu_0;
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_01 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.01)";
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_05 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.05)";
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

title2 height=7pt "Veličina uzorka  je 20"; 
%power_t_test(20, &n_rep, &seed, &distribution, &mu, &sigma); 

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.PVALUES out=_SeriesPlotTaskData;
	by mu_0;
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_01 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.01)";
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_05 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.05)";
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

title2 height=7pt "Veličina uzorka  je 50";
%power_t_test(50, &n_rep, &seed, &distribution, &mu, &sigma); 

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.PVALUES out=_SeriesPlotTaskData;
	by mu_0;
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_01 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.01)";
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_05 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.05)";
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;

title2 height=7pt "Veličina uzorka  je  100";
%power_t_test(100, &n_rep, &seed, &distribution, &mu, &sigma); 

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.PVALUES out=_SeriesPlotTaskData;
	by mu_0;
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_01 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.01)";
run;

proc sgplot data=_SeriesPlotTaskData;
	series x=mu_0 y=p_value_05 /;
	xaxis grid label="Nulta hipoteza";
	yaxis grid label="P-vrijednost (0.05)";
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
	
/* ANALIZA GENERIRANIH BROJEVA */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=WORK.GENERATE out=Work.SortTempTableSorted;
	by mu_0;
run;

/* Exploring Data */
proc univariate data=Work.SortTempTableSorted;
	ods select Histogram;
	var x;
	histogram x;
	by mu_0;
run;

proc delete data=Work.SortTempTableSorted;
run;