
*učitavanje podataka;
data cars;    
	set sashelp.cars; 
	keep INVOICE MPG_CITY  WEIGHT;
run;

* a dio -> modeliranje marginalnih distribucija od cars podataka, fitanje kopula, 
generiranje 200 podataka -> transformiranih u uniformnu distribuciju;
proc copula data = cars;
   fit normal; *koristimo normalnu kopulu;
   simulate / seed=1234 ndraws=200 marginals=empirical  outuniform=UnifData;
run;

*b dio -> primjena inverz kumulativne funkcije distribucije;
data Sim;
	set UnifData; 
	exp = quantile("Exponential", Invoice); 
	lognormal_1 = quantile("LogNormal", MPG_CITY);
	lognormal_2 = quantile("LogNormal", WEIGHT);
	keep exp lognormal_1 lognormal_2;
run;

* c dio -> usporedba varijabla s onima u završenom data setu;
proc corr data = cars Spearman noprob plots=matrix(hist);
   title "Original Cars";
run;

proc corr data=Sim Spearman noprob plots=matrix(hist);
   title "Simulated Cars";
run;

*Spearmanovi koeficijenti korelacije su prilično slični u originalnim i simuliranim podacima.
Histogrami za MPG_City i WEIGHT se malo razlikuju;
*Spearman Correlation Coefficients - SIMULATED CARS, N = 200
  	exp 	lognormal_1 	lognormal_2
exp 	1.00000 	-0.70594 	0.64178
lognormal_1 	-0.70594 	1.00000 	-0.87309
lognormal_2 	0.64178 	-0.87309 	1.00000
*Spearman Correlation Coefficients - ORIGINAL CARS,  N = 428
  	Invoice 	MPG_City 	Weight
Invoice
 
	1.00000 	-0.69824 	0.66565
MPG_City
MPG (City)
	-0.69824 	1.00000 	-0.86451
Weight
Weight (LBS)
	0.66565 	-0.86451 	1.00000;


