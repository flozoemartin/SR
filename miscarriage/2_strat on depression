********************************************************************************************************

* Meta-analysis of estimates from studies that stratified on depression, comparing to: unmedicated depressed or treatment with another type of antidepressant not under study

* Author: Flo Martin

* Date: 05/09/2023

********************************************************************************************************

* Start logging 

	log using "$Logdir\2_strat on depression", name(strat_on_depression) replace

********************************************************************************************************

* Change working directory for saving figures

	cd "/file/space/for/saving/figures/"

	* Make the dataframe out of the raw data where possible - for those with just OR(95%CI) provided in the paper put '.' (missing) to fill in later:

		clear

			input float trial str25 author float adtype year rt ht rc hc nt nc adj

				13 "Ban" 1 2012 1982 13151 442 3647 13 13 1
				15 "Kjaesgaard" 1 2013 210 1674 105 820 15 15 1
				18 "Johansen" 1 2015 2359 20612 . . 18 18 1
				20 "Almeida" 1 2016 165 1955 720 10719 20 20 .
				21 "Evans-Hoeker" 1 2018 2 16 5 72 21 21 .	
				27 "Kitchin" 1 2022 385 2216 1205 8276 27 27 .
				32 "Einarson" 2 2001 16 150 18 150 32 32 .
				35 "Ban" 2 2012 1539 10132 443 3019 35 35 .
				36 "Klieger-Grossman" 2 2012 32 213 34 212 36 36 .
				39 "Evans-Hoeker" 2 2018 11 57 4 25 39 39 .
				40 "Wu" 2 2019 35 179 7 44 40 40 .
				42 "Einarson" 3 2001 18 150 16	150 42 42 .
				44 "Richardson" 3 2019 46 281 114 843 44 44 1
				46 "Ankarfeldt" 3 2021 143 1201 2815 27330 46 46 1

		end

	* Define labels for forest plot components 
	* trial (1,2,3...) to "Author (year)" 

		label define trial_lb 	13"*Ban {it:et al.}" ///
								15"*Kjaesgaard {it:et al.}" ///
								18"*Johansen {it:et al.}"	///
								20"Almeida {it:et al.}" ///
								21"Evans-Hoeker {it:et al.}" ///
								27"Kitchin {it:et al.}"	///
								32"Einarson {it:et al.}" ///
								35"Ban {it:et al.}" ///
								36"Klieger-Grossman {it:et al.}" ///
								39"Evans-Hoeker {it:et al.}" ///
								40"Wu {it:et al.}" ///
								42"Einarson {it:et al.}" ///
								44"*Richardson {it:et al.}" ///
								46"*Ankarfeldt {it:et al.}"

		label values trial trial_lb

	* adtype (1,2,3) to groups on the forest plot "AD vs none" etc.

		label define adtype_lb 	1"AD use vs unmedicated depression" ///
								2"SSRIs vs other ADs" ///
								3"SNRIs vs other ADs"  
		
		label values adtype adtype_lb

	* nt (1,2,3...) to "Number of spontaneous abortion/total number of exposed"
	
		label define nt_lb 	13"1,982/13,151" ///
							15"210/1,674" ///
							18"2,359/20,612" ///
							20"165/1,955" ///
							21"2/16" ///
							27"385/2,216" ///
							32"16/150" ///
							35"1,539/10,132" ///
							36"32/213" ///
							39"11/57" ///
							40"35/179" ///
							42"18/150" ///
							44"46/281" ///
							46"143/1,201"
								
		label values nt nt_lb 

	* nc (1,2,3...) to "Number of spontaneous abortion/total number of controls"

		label define nc_lb 	13"442/3,647" ///
							15"105/820" ///
							18"NA" ///
							20"720/10,719" ///
							21"5/72" ///
							27"1,205/8,276" ///
							32"18/150" ///
							35"443/3,019" ///
							36"34/212" ///
							39"4/25" ///
							40"7/44" ///
							42"16/150" ///
							44"144/843" ///
							46"2,815/27,330"

		label values nc nc_lb


	* Calculat the log odds from raw numbers

		gen logor=log((rt/ht)/(rc/hc))

	* Calculate the standard error from the raw numbers

		gen selogor=sqrt(1/rt+1/ht+1/rc+1/hc)

	* Calculate the 95%CIs from the log odds and SE

		gen lci=exp(logor-(1.96*selogor))
		gen uci=exp(logor+(1.96*selogor))

	* For studies with their own adjusted results provided in the paper switch out where you have put a '.' in the dataframe (above) with the relevant numbers:

	* replace logor = log(OR given in the paper) if trial == Whichever study you are filling in
	* replace selogor = (((log(upCI in paper))-(log(lCI in paper)))/3.92) if trial === Whichever study you are filling in

		replace logor = log(1.34) if trial ==13 
		replace selogor = (((log(1.51))-(log(1.2)))/3.92) if trial ==13 // Ban

		replace logor = log(1) if trial ==15
		replace selogor = (((log(1.24))-(log(0.8)))/3.92) if trial ==15 // Kjaesgaard

		replace logor = log(0.97) if trial ==18
		replace selogor = (((log(1.16))-(log(0.81)))/3.92) if trial ==18 // Johansen

		replace logor = log(1) if trial ==44
		replace selogor = (((log(1.53))-(log(0.655)))/3.92) if trial ==44 // Richardson
		
		replace logor = log(1.23) if trial ==46
		replace selogor = (((log(1.46))-(log(1.04)))/3.92) if trial ==46 // Ankarfeldt		


	* Calculate the 95%CIs like you did above but with your new inputted log odds from the papers

		replace lci=exp(logor-(1.96*selogor))
		replace uci=exp(logor+(1.96*selogor))

	* Now use meta esize to make the dataframe for meta funnelplot/admetan to use

		meta esize rt ht rc hc


	* As we have some gaps where we don't have raw data for meta esize to use, we can use what we calculated in the first stage to fill in the gaps: re-run lines 10-96 and use what you calculated to fill in the gaps in the esize dataset

		replace _meta_es = logor if adj==1
		replace _meta_se = selogor if adj==1
		replace _meta_cil = lci if adj==1
		replace _meta_ciu = uci if adj==1

	* Total number of people in the study

		replace _meta_studysize = 331414 if trial ==13
		replace _meta_studysize = 1005319 if trial ==15
		replace _meta_studysize = 1281418 if trial ==18
		replace _meta_studysize = 2529 if trial ==44
		replace _meta_studysize = 28568 if trial ==46

	* And the meta-analysis forest plot

		admetan _meta_es _meta_se, eform by(adtype) nowt label(namevar=trial, yearvar=year) lcols(nt nc) forest(hetstat(p) leftj) random saving(soph_analysis, replace)

		use soph_analysis, clear
		drop if _USE ==4 | _USE ==5
		label var _LABELS `"{bf:Study author (year)}"'
		replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0

		label var nt `"`"{bf:Treated}"' `"n/N"'"'
		label var nc `"`"{bf:Controls}"' `"n/N"'"'
		label var _EFFECT `"`"{bf:Odds ratio}"' `"{bf:(95% CI)}"'"'
		label var _WT `"`"{bf:Weight}"' `"{bf:%}"'"'

		forestplot, useopts nostats nowt rcols(_EFFECT _WT) graphregion(color(white)) xlab(0.4,1,9) name("Soph_analysis_RandR_v2_depstrat", replace)
		
		graph export Soph_analysis_randr_v2_depstrat.pdf, name(Soph_analysis_RandR_v2_depstrat) replace

********************************************************************************************************

* Stop logging

	log close strat_on_depression
	
	translate "$Logdir\2_strat on depression.smcl" "$Logdir\2_strat on depression.pdf", replace
	
	erase "$Logdir\2_strat on depression.smcl"

*********************************************************************************************************
