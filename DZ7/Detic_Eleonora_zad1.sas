%include "/home/u58223001/RS zadaće/Zadaća 7/jackboot.sas";

libname lib "/home/u58223001/RS zadaće/Zadaća 7";

%macro analyze(data=, out=);
	proc means noprint data=&data median;
		output out=&out(drop=_freq_ _type_) median=;
		var x;
		%bystmt;
	run;

%mend;

%jack(data=lib.pills_efron);


%macro analyze(data=, out=);
	proc means noprint data=&data stderr;
		output out=&out(drop=_freq_ _type_) stderr=;
		var x;
		%bystmt;
	run;

%mend;

%jack(data=lib.pills_efron);

