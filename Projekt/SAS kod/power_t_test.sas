%macro power_t_test(n, n_rep, seed, distribution, mu, sigma);
/*
---------------------------------------------------------------------
n - size of sample
n_reep - number of replications
seed - seed for number generating
distribution - distribution label, possible values are: "N" - Normal Distribution
                                                        "L" - Laplace Distribution
                                                        "G" - Gamma Distribution
                                                        "W" - Weibull Distribution
                                                        "U" - Uniform Distribution
mu - population mean
sigma - population standard deviation

--------------------------------------------------------------------- 
*/

data generate;
	call streaminit(&seed);
	do mu_0 = 500 to 700 by 20; 
		do rep = 1 to &n_rep;
			do i = 1 to &n;
				if &distribution = "N" then do;
					x = RAND("Normal", &mu, &sigma); 
					x = x - mu_0; 
				end;
				if &distribution = "L" then do;
					x = RAND('LAPLace', &mu, &sigma / sqrt(2)); 
					x = x - mu_0; 
				end;
				if &distribution = "G" then do;
					x = 42*sqrt(2)*RAND('GAMMa', 0.5,1)+600-21*sqrt(2); 
					x = x - mu_0; 
				end;
				if &distribution = "W" then do;
					x = 21/sqrt(5)*RAND('WEIBull', 0.5,1)+600-42/sqrt(5);
					x = x - mu_0; 
				end;
				if &distribution = "U" then do;
					x = RAND("Uniform", &mu - (&sigma /2) * sqrt(12), &mu + (&sigma /2) * sqrt(12)); 
					x = x - mu_0; 
				end;
				output;
			end;
  			output;
  		end;
  		output;
 	end;
 	label rep = "Repetition";
run;


proc means data=generate noprint;                                                                                              
  	var x;                                                                                                         
  	by mu_0 rep;  
  	output out=t_all t=t; 
run; 


data t_all;
	set t_all;
	keep mu_0 rep t;
run;


data tall;
	set t_all;	
	
	t_crit_01 = tinv(0.01, &n - 1);
   	fraction_crit_01=(t le t_crit_01);
   	
   	t_crit_05 = tinv (0.05, &n - 1);
   	fraction_crit_05=(t le t_crit_05);
run;

proc means data=tall nway noprint; 
	var fraction_crit_01 fraction_crit_05;
 	output out=fractions mean=; 
 	class mu_0;
run;

data fractions;
	set fractions;
	keep mu_0 fraction_crit_01 fraction_crit_05;
run;

proc print data = fractions;
run;

%mend power_t_test;