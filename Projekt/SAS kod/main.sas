libname lib "/home/u58223001/RS PROJEKT";
%include "/home/u58223001/RS PROJEKT/power_t_test.sas";

%let seed = 1234;
%let n_rep = 500;
%let mu = 600;
%let sigma = 42;

title1 "Normalna distribucija";
%let distribution = "Normal";

title2 height=7pt "Veličina uzorka  je 10" ;
%power_t_test(10, &n_rep, &seed, &distribution, &mu, &sigma); 

title2 height=7pt "Veličina uzorka  je 15";
%power_t_test(15, &n_rep, &seed, &distribution, &mu, &sigma);

title2 height=7pt "Veličina uzorka  je 20"; 
%power_t_test(20, &n_rep, &seed, &distribution, &mu, &sigma); 

title2 height=7pt "Veličina uzorka  je 50";
%power_t_test(50, &n_rep, &seed, &distribution, &mu, &sigma); 

title2 height=7pt "Veličina uzorka  je  100";
%power_t_test(100, &n_rep, &seed, &distribution, &mu, &sigma); 