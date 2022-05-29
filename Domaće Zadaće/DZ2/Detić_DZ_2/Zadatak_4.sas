%LET SEED = 47755;
%LET N = 300;

*a dio;

DATA BUYERS;
	CALL STREAMINIT(&SEED);
	DO REP=1 TO &N;
		X = RAND ('BERNOULLI', .30);
		IF X = 1 then do;
				time_A =  RAND('EXPOnential', 3);
			end;
		ELSE do;
				time_A =  RAND('GAMMa', 5);
			end;
		Y = RAND ('BERNOULLI', .40);
		IF Y = 1 then do;
				time_B =  RAND('EXPOnential', 4);
			end;
		ELSE do;
				time_B =  RAND('GAMMa', 7);
			end;
		OUTPUT;
		
	END;
	drop rep X Y;
RUN;

* b dio - vrijeme je u satima;
title "Vrijeme potrebno da se usluži svih 300 kupaca - u satima";
proc sql;
    select sum(time_A)/60 as Sum_Time_A, sum(time_B)/60 as Sum_Time_B
    from work.buyers;
quit;

* c dio;
title "Prosječno vrijeme kupovine u trgovinama A i B";
proc means data = buyers mean;
	var time_A time_B;
run; 
*60 x 12 = 720 minuta, ovaj dio sam ručno namještala, zbrajala sam k najmanjih dok nebi premašila 12 sati;
proc sql;
	create table buyers_smallest_A as
	SELECT time_A FROM buyers (OBS = 161) 
	ORDER BY time_A ASC;
run;
proc sql;
	create table buyers_smallest_B as
	SELECT time_B FROM buyers (OBS = 110)
	ORDER BY time_B ASC;
run;
title "Maximalan broj usluženih kupaca trgovina A u 12 sati- 161";
proc sql;
    select sum(time_A)/60 as Sum_Time_A
    from work.buyers_smallest_A;
quit;
title "Maximalan broj usluženih kupaca trgovina B u 12 sati- 110";
proc sql;
    select  sum(time_B)/60 as Sum_Time_B
    from work.buyers_smallest_B;
quit;

title "Promjena u distribuciji kupovine druge skupine kupaca";
* d dio;
DATA BUYERS2;
	CALL STREAMINIT(&SEED);
	DO REP=1 TO &N;
		X = RAND ('BERNOULLI', .30);
		IF X = 1 then do;
				time_A =  RAND('EXPOnential', 3);
			end;
		ELSE do;
				time_A =  RAND('EXPOnential', 5);
			end;
		Y = RAND ('BERNOULLI', .40);
		IF Y = 1 then do;
				time_B =  RAND('EXPOnential', 4);
			end;
		ELSE do;
				time_B =  RAND('EXPOnential', 7);
			end;
		OUTPUT;
		
	END;
	drop rep X Y;
RUN;

*e dio; 
title2 "Vrijeme potrebno da se svi usluže";
proc sql;
    select sum(time_A)/60 as Sum_Time_A, sum(time_B)/60 as Sum_Time_B
    from work.buyers2;
quit;

* f dio;
title2 "Prosječno vrijeme kupovine u trgovinama";
proc means data = buyers2 mean;
	var time_A time_B;
run; 

proc sql;
	create table buyers_smallest_A as
	SELECT time_A FROM buyers2 (OBS = 163) 
	ORDER BY time_A ASC;
run;
proc sql;
	create table buyers_smallest_B as
	SELECT time_B FROM buyers2 (OBS = 126)
	ORDER BY time_B ASC;
run;
title2 "Maximalan broj usluženih kupaca trgovina A u 12 sati- 163";
proc sql;
    select sum(time_A)/60 as Sum_Time_A
    from work.buyers_smallest_A;
quit;
title2 "Maximalan broj usluženih kupaca trgovina B u 12 sati- 126";
proc sql;
    select  sum(time_B)/60 as Sum_Time_B
    from work.buyers_smallest_B;
quit;

* g dio;
%LET N = 10000;

DATA BUYERS3;
	CALL STREAMINIT(&SEED);
	DO REP=1 TO &N;
		X = RAND ('BERNOULLI', .30);
		IF X = 1 then do;
				time_A =  RAND('EXPOnential', 3);
			end;
		ELSE do;
				time_A =  RAND('GAMMa', 5);
			end;
		Y = RAND ('BERNOULLI', .40);
		IF Y = 1 then do;
				time_B =  RAND('EXPOnential', 4);
			end;
		ELSE do;
				time_B =  RAND('GAMMa', 7);
			end;
		OUTPUT;
		
	END;
	drop rep X Y;
RUN;
title "G dio";
proc means data=buyers3 mean sum std skew kurt stderr;
	var time_A time_B;
run;

*h dio;
title "H dio";
DATA BUYERS4;
	CALL STREAMINIT(&SEED);
	DO REP=1 TO &N;
		X = RAND ('BERNOULLI', .30);
		IF X = 1 then do;
				time_A =  RAND('EXPOnential', 3);
			end;
		ELSE do;
				time_A =  RAND('EXPOnential', 5);
			end;
		Y = RAND ('BERNOULLI', .40);
		IF Y = 1 then do;
				time_B =  RAND('EXPOnential', 4);
			end;
		ELSE do;
				time_B =  RAND('EXPOnential', 7);
			end;
		OUTPUT;
		
	END;
	drop rep X Y;
RUN;
proc means data=buyers4 mean sum std skew kurt stderr;
	var time_A time_B;
run;



