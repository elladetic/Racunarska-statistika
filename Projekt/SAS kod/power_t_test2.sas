%macro power_t_test2(n, n_rep, seed, distribution, mu, sigma);

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
		do rep = 1 to &n_rep by 1;
			do i = 1 to &n by 1;
				if &distribution = "N" then do;
					x = RAND("Normal", &mu, &sigma); 
					x = x - mu_0; 
				end;
				if &distribution = "L" then do;
					x = RAND('LAPLace', &mu, &sigma / sqrt(2)); 
					x = x - mu_0; 
				end;
				if &distribution = "G" then do;
					x = 42*sqrt(12) * RAND('GAMMa', 0.5, 1) + 600-21*sqrt(12); 
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
run;

ods exclude all;

proc ttest data = generate side = L alpha = 0.01;
	var x;
	by mu_0 rep; 
	ods output ttests = ttValues_01(keep=tvalue probt mu_0 rep);
run;

ods exclude none;

data fraction_01;
	set ttValues_01;	
	
	t_crit_01 = tinv(0.01, &n - 1);
   	fraction_crit_01 = (tvalue le t_crit_01);
   	fraction_pvalue_01 = (probt le 0.01);
   	
run;

proc means data = fraction_01 nway noprint; 
	var fraction_crit_01 fraction_pvalue_01;
 	output out = fractions_01 mean=; 
 	class mu_0;
run;

data fractions_01;
	set fractions_01;
	keep mu_0 fraction_crit_01 fraction_pvalue_01;
run;


ods exclude all;

proc ttest data = generate side=L alpha = 0.05;
	var x;
	by mu_0 rep; 
	ods output ttests = ttValues_05(keep=tvalue probt mu_0 rep);
run;

ods exclude none;

data fraction_05;
	set ttValues_05;	
  
   	t_crit_05 = tinv (0.05, &n - 1);
   	fraction_crit_05 = (tvalue le t_crit_05);
	fraction_pvalue_05 = (probt le 0.05);
run;

proc means data = fraction_05 nway noprint; 
	var fraction_crit_05 fraction_pvalue_05;
 	output out = fractions_05 mean=; 
 	class mu_0;
run;

data fractions_05;
	set fractions_05;
	keep mu_0 fraction_crit_05 fraction_pvalue_05;
run;


data fractions;
  	merge fractions_01 fractions_05;
  	by mu_0;
run;

proc print data = fractions;
run;

%mend;


