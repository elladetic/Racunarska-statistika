libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";

%let seed = 15;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;
%let alpha = 0.01;

*/
-------------------------------------------------------------------------------------------
/*;
%let n = 10;
%let distribution = "N";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);

data all_1;
	set fractions;
run;

%let distribution = "L";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let distribution = "G";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let distribution = "U";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let distribution = "W";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, n = 10";
	vline mu_0 / response=fraction_crit group=distribution;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;

*/
-------------------------------------------------------------------------------------------
/*;
%let n = 15;
%let distribution = "N";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);

data all_1;
	set fractions;
run;

%let distribution = "L";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let distribution = "G";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let distribution = "U";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let distribution = "W";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, n = 15";
	vline mu_0 / response=fraction_crit group=distribution;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;
*/
-------------------------------------------------------------------------------------------
/*;
%let n = 20;
%let distribution = "N";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);

data all_1;
	set fractions;
run;

%let distribution = "L";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let distribution = "G";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let distribution = "U";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let distribution = "W";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, n = 20";
	vline mu_0 / response=fraction_crit group=distribution;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;
*/
-------------------------------------------------------------------------------------------
/*;
%let n = 50;
%let distribution = "N";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);

data all_1;
	set fractions;
run;

%let distribution = "L";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let distribution = "G";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let distribution = "U";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let distribution = "W";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, n = 50";
	vline mu_0 / response=fraction_crit group=distribution;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;
*/
-------------------------------------------------------------------------------------------
/*;
%let n = 100;
%let distribution = "N";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);

data all_1;
	set fractions;
run;

%let distribution = "L";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_2 as 
	select * from all_1
	union all
	select * from fractions;
run;

%let distribution = "G";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_3 as 
	select * from all_2
	union all
	select * from fractions;
run;

%let distribution = "U";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_4 as 
	select * from all_3
	union all
	select * from fractions;
run;

%let distribution = "W";
%power_t_test(&n, &n_rep, &seed,  &distribution, &mu, &sigma, &alpha);
proc sql;
	create table all_final as 
	select * from all_4
	union all
	select * from fractions;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.ALL_FINAL;
	title height=10pt "Alpha = 0.01, n = 100";
	vline mu_0 / response=fraction_crit group=distribution;
	yaxis grid;
run;

ods graphics / reset;

proc datasets library=work nodetails nolist nowarn;
   	delete all_1 all_2 all_3 all_4 all_final fractions;
run;
