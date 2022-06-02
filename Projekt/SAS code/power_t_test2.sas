%macro power_t_test2(n, n_rep, seed, distribution, mu, sigma, alpha);

/*
---------------------------------------------------------------------
INPUT
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
alpha = statistical significance level

--------------------------------------------------------------------
OUTPUT
TABLE GENERATE - a table of generated data stored in the variable x
TABLE FRACTIONS - a table of generated values for the critical area stored in the variable fraction_crit
				  and generated values for the pvalues stored in the variabe fraction_pvalue

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
				if &distribution ="G" then do;
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

ods exclude all;

proc ttest data = generate side = L alpha = &alpha;
	var x;
	by mu_0 rep; 
	ods output ttests = ttValues(keep=tvalue probt mu_0 rep);
run;

ods exclude none;

data fraction;
	set ttValues;	
	t_crit = tinv(&alpha, &n - 1);
   	fraction_crit = (tvalue le t_crit_01);
   	fraction_pvalue = (probt le &alpha);
   	
run;

proc means data = fraction nway noprint; 
	var fraction_crit fraction_pvalue;
 	output out = fractions mean=; 
 	class mu_0;
run;

data fractions;
	set fractions;
	keep mu_0 fraction_crit fraction_pvalue;
run;

proc print data = fractions;
run;

%mend;


