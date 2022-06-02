libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";

%let seed = 15;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;
%let alpha = 0.05;

*/
-------------------------------------------------------------------------------------------
/*;

%let distribution = "N";
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

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, distribution = Normal";
	vline mu_0 / response=fraction_crit group=n;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

*/
-------------------------------------------------------------------------------------------
/*;

%let distribution = "G";
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

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, distribution = Gamma";
	vline mu_0 / response=fraction_crit group=n;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

*/
-------------------------------------------------------------------------------------------
/*;

%let distribution = "U";
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

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, distribution = Uniform";
	vline mu_0 / response=fraction_crit group=n;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

*/
-------------------------------------------------------------------------------------------
/*;

%let distribution = "L";
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

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, distribution = Laplace";
	vline mu_0 / response=fraction_crit group=n;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

*/
-------------------------------------------------------------------------------------------
/*;

%let distribution = "W";
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

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, distribution = Weibull";
	vline mu_0 / response=fraction_crit group=n;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;