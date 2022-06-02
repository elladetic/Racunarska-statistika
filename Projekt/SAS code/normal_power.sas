libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";

%let seed = 15;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;
%let alpha = 0.05;
%let distribution = "N";


*/
-------------------------------------------------------------------------------------------
/*;

%let alpha = 0.05;
title1 "Alpha = 0.05";

%let n = 10;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
data all_1;
	set fractions;
run;

%let n = 15;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let n = 20;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let n = 50;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let n = 100;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

data all_final;
	set all_final;
	mu_0_dif = mu_0 - 600;
	drop distribution mu_0;
	rename mu_0_dif = mean fraction_crit = power;
run; 

proc sql;
	create table all_final_pos as
 	select * from all_final where mean > 0 ;
run;
 
proc sort data = all_final_pos;
	 by mean n;
run;	 

title2 "Our values";
proc print data = all_final_pos;
run;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

title2 "Power procedure values";
proc power;
	onesamplemeans
	mean   = 20 40 60 80 100
	ntotal = 10 15 20 50 100
	stddev = &sigma
	alpha = &alpha
	sides = 1
	power  = .;
run;

*/
-------------------------------------------------------------------------------------------
/*;

%let alpha = 0.01;
title1 "Alpha = 0.01";

%let n = 10;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
data all_1;
	set fractions;
run;

%let n = 15;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let n = 20;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let n = 50;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let n = 100;
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

data all_final;
	set all_final;
	mu_0_dif = mu_0 - 600;
	drop distribution mu_0;
	rename mu_0_dif = mean fraction_crit = power;
run; 

proc sql;
	create table all_final_pos as
 	select * from all_final where mean > 0 ;
run;
 
proc sort data = all_final_pos;
	 by mean n;
run;	 

title2 "Our values";
proc print data = all_final_pos;
run;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

title2 "Power procedure values";
proc power;
	onesamplemeans
	mean   = 20 40 60 80 100
	ntotal = 10 15 20 50 100
	stddev = &sigma
	alpha = &alpha
	sides = 1
	power  = .;
run;
