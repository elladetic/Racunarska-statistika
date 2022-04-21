*generiramo ne nužno normalne, već neprekidne razdiobe
*Iman-Conover metoda -> poznate marginalne i rang korelacije, koristi se Spear. koeficijent;

proc iml; *poseban modul koji nam treba;
start ImanConoverTransform(Y, C); *to je transformacija -> unutar stupaca;
   X = Y; 
   N = nrow(X);
   R = J(N, ncol(X));
   /* compute scores of each column */
   do i = 1 to ncol(X);
      h = quantile("Normal", rank(X[,i])/(N+1) );
      R[,i] = h;
   end;
   /* these matrices are transposes of those in Iman & Conover */
   Q = root(corr(R)); 
   P = root(C); 
   S = solve(Q,P);                      /* same as  S = inv(Q) * P; */
   M = R*S;             /* M has rank correlation close to target C */

   /* reorder columns of X to have same ranks as M.
      In Iman-Conover (1982), the matrix is called R_B. */
   do i = 1 to ncol(M);
      rank = rank(M[,i]);
      tmp = X[,i];       /* TYPO in first edition */
      call sort(tmp);
      X[,i] = tmp[rank];
   end;
   return( X );
finish; *ovdje zavrsava onaj start;

/* Step 1: Specify marginal distributions */
call randseed(1); *specificiranje marginalnih distribucijA;
N = 100; *DULJINA UZORKA;
A = j(N,4);   y = j(N,1); *ovo je matrica A;
distrib = {"Normal" "Lognormal" "Expo" "Uniform"};
do i = 1 to ncol(distrib);
   call randgen(y, distrib[i]);
   A[,i] = y;
end;

/* Step 2: specify target rank correlation - simetricna matrica */
C = { 1.00  0.75 -0.70  0, 
      0.75  1.00 -0.95  0,
     -0.70 -0.95  1.00 -0.2,
      0     0    -0.2   1.0};

X = ImanConoverTransform(A, C); *ovo je poziv te funkcije; 
RankCorr = corr(X, "Spearman"); *ovdje se sprema matrica korelacija;
*da vidimo jel ova matrica odgovara matrici C;

*print RankCorr[format=5.2];

/* write to SAS data set */
*ovdje želim spremiti taj simulirani multivarijatni vektor - 4 varijable;
create MVData from X[c=("x1":"x4")];  
	append from X;  
	close MVData;
quit; * kraj iml modula;

ods select none;

proc copula data=MVData;
   var x1-x4;
   fit normal;
   simulate / seed=1234  ndraws=100 marginals=empirical  outuniform=UnifData;
   *out = noprint;
run;

ods select all;


data Sim; *ovo je data set nad kojim radimo;
	set UnifData;
	normal = quantile("Normal", x1);
	lognormal = quantile("LogNormal", x2);
	expo = quantile("Exponential", x3);
	uniform = x4;
	keep normal lognormal expo uniform;
run;


title "Fisher";
proc corr data=Sim Spearman nosimple fisher;
run;
*vidimo da stvarna vrijednost upada u 95% pouzdan interval;
*npr za normal i lognormalje Spearmanov koeficijent 0.74590, dok je pouzdan interval za njega 
*[0.648505, 0.824504];



   
   
  