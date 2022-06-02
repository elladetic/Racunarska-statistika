libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";
%include "/home/u58223001/RS PROJEKT/power_t_test2.sas";

%let seed = 15;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;
%let alpha = 0.01;
%let distribution = "N";
%let n = 10;

title "Power_t_test";
%power_t_test(&n, &n_rep, &seed, &distribution, &mu, &sigma, &alpha);
proc print data = fractions;
run;

title "Power_t_test complex version";
%power_t_test2(&n, &n_rep, &seed, &distribution, &mu, &sigma, &alpha);
proc print data = fractions;
run;

