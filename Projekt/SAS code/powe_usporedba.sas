proc power;
   onesamplemeans
      mean   = 20 40 /*razlika između populacijskog meana i 580*/
      ntotal = 10 15 20 50 100
      stddev = 42
      alpha = 0.05
      sides = 1
      power  = .;
run;

/* što ovo znaci? znaci da bi snaga mog test bila 0.8 (tj. da u 80% slučajeva mogu zaključiti da je razlika meanova veća od 20)
					na uzorku duljine 48*/
					
					
/* za zadnji dio zadataka */ 

proc power;
   onesamplemeans
      mean   = 20
      ntotal = 5 to 500 by 20
      stddev = 42
      alpha = 0.01
      sides = 1
      power  = .;
run;

proc power;
   onesamplemeans
      mean   = 20
      ntotal = 5 to 500 by 20
      stddev = 42
      alpha = 0.05
      sides = 1
      power  = .;
run;
