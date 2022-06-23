%let N = 50;
%let NumSamples = 100;

data RegSim2(keep= SampleID i x y);
	call streaminit(1);
	do i = 1 to &N;
		x = rand("Uniform");         
		eta = 1 - 2*x;                
		do SampleID = 1 to &NumSamples;
			y = eta + rand("Normal", 0, 0.5);
			output; 
		end;
	end; 
run;

proc sort data=RegSim2;
	by SampleID i;
run;

proc reg data=RegSim2 outest=OutEst NOPRINT;
	by SampleID;
	model y = x;
run;

*elipsa;
ods graphics on;
proc corr data=outest noprob plots=scatter(alpha=.1);
	label x="Estimated Coefficient of x" Intercept="Estimated Intercept";
	var Intercept x;
	ods exclude VarInformation;
run;

data outest;
	set outest;
	keep _RMSE_ x;
run;

proc univariate data=outest;
	var _RMSE_;
run; *MC procjena je 0.507648 	
*pouzdani intervali su [0.443575, 0.587894];

proc univariate data=outest;
	ods select Histogram GoodnessOfFit;
	var _RMSE_;
	histogram _RMSE_ / normal(mu=est sigma=est);
run;

* pvrijednost je velika, ne odbacujemo H_0 o normalnosti ASD