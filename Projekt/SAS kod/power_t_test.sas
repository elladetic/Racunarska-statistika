
%macro power_t_test(n, n_rep, seed, distribution, mu, sigma);

data generate;
	call streaminit(&seed);
	do mu_0 = 500 to 700 by 20; 
		do rep = 1 to &n_rep;
			do i = 1 to &n - 1;
				x = RAND(&distribution, &mu, &sigma); 
				x = x - mu_0; 
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
   	fraction_crit_01_left=(t le t_crit_01);
   	fraction_crit_01_right=(t ge -t_crit_01);
   	
   	t_crit_05 = tinv (0.05, &n - 1);
   	fraction_crit_05_left=(t le t_crit_05);
   	fraction_crit_05_right=(t ge -t_crit_05); 
run;

proc means data=tall nway noprint; 
	var fraction_crit_01_left fraction_crit_01_right fraction_crit_05_left fraction_crit_05_right;
 	output out=fraction mean=; 
 	class mu_0;
run;

data pvalues;
	set fraction;
	rename fraction_crit_01_right= p_value_01  fraction_crit_05_right = p_value_05;
	keep mu_0 fraction_crit_01_right fraction_crit_05_right;
run;

proc print data = pvalues;
run;

%mend power_t_test;


