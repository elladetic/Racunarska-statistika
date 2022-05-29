libname lib "/home/u58223001/RS zadaće/Zadaća 8";  


data my_data;
	set lib.pills_efron;
run; 

title "Medijan originalnih podataka";

proc means data = my_data median;
	var x;
run;
	
title "Bootstraping metoda";
proc surveyselect 
	data = my_data
	seed=775566
	method=urs              
	samprate=1 
	reps=500
	out = my_boot;
run;

proc means data= my_boot nway noprint;
	by Replicate;
	output out=median_all median = median;
run;

title "Neparametarska bootstrap procjena medijana";
proc means data = median_all mean;	
	var median;
run;
	
*procjena pristranosti je: 33.4075000 - 32 = 1.4075;

data error_all;
	set median_all;
	error_ = abs(median - 32);
	keep error_;
run;

title "Boostrap procjena greske";
proc means data = error_all mean;
	var error_;
run;