*Project 1-Initial analysis;

*Import the data;
proc import datafile = "C:\Users\cottonel\Documents\BIOS6623_AdvancedData\Project_One\project1_CleanedDataSas.csv"
	out = hiv dbms = csv replace;
	getnames = yes;
run;

*PROC MCMC---Copy Nichole's code from inclass model selection stuff;
*VLoad as outcome;
*Autocorrelation plots look bad...;
proc mcmc data = hiv nbi = 30000 nmc = 300000 plots = all DIC;
	parms betaint 0 betaSmokerInd 0 betaDrinksInd 0 betaRaceInd 0 betaEducationInd 0 betaAdherenceInd 0 betaIncomeMedInd 0 
	betaIncomeHighInd 0 betaHashVInd 0 betaBMI 0 betaAge 0 betaHardDrugs 0 betaLogVloadBase 0;
	parms sigma2 1;
	prior betaint betaSmokerInd betaDrinksInd betaRaceInd betaEducationInd betaAdherenceInd betaIncomeMedInd 
	betaIncomeHighInd betaHashVInd betaBMI betaAge betaHardDrugs betaLogVloadBase ~ normal(mean = 0, var = 1000);
	prior sigma2 ~igamma(shape = 2.001, scale = 1.001);
	mu = betaint + betaSmokerInd*SmokerInd + betaDrinksInd*DrinksInd + betaEducationInd*EducationInd + betaAdherenceInd*AdherenceInd
			+ betaIncomeMedInd*IncomeMedInd + betaIncomeHighInd*IncomeHighInd + betaHashVInd*HashVInd + betaBMI*BMI +
			betaAge*Age + betaHardDrugs*HardDrugs + betaLogVloadBase*logVLoadBase;
	model logVloadDiff ~ normal(mu, var = sigma2);
	title "Model 1: Full model with log(VLoad) and All variables";
run;

proc mcmc data = hiv nbi = 30000 nmc = 300000 plots = all DIC;
	parms betaint 0 betaHardDrugs 0 betaLogVloadBase 0;
	parms sigma2 1;
	prior betaint betaHardDrugs betaLogVloadBase ~ normal(mean = 0, var = 1000);
	prior sigma2 ~igamma(shape = 2.001, scale = 1.001);
	mu = betaint + betaHardDrugs*HardDrugs + betaLogVloadBase*logVLoadBase;
	model logVloadDiff ~ normal(mu, var = sigma2);
	title "Model 1: Crude Model with log(VLoad)";
run;

*The hard drugs estimate didn't change significantly---DONE! GOLDEN!;
