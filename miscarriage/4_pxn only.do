
*********************************************************************************************************************

* Meta-analysis of studies that defined their exposure using prescription registries only (i.e., omitting studies that used self-reported or clinician reported antidepressant use during pregnancy)

* Author: Flo Martin

* Date: 29/10/2023

*********************************************************************************************************************

* Start logging

	log using "$Logdir\4_pxn only", name(pxn_only) replace

*********************************************************************************************************************

* Change working directory for saving figures

	cd "$Graphdir"

	* Make the dataframe out of the raw data where possible - for those with just OR(95%CI) provided in the paper put '.' (missing) to fill in later:

		clear

			input float trial str20 author adtype year rt ht rc hc nt nc adj
			
				9 "Nakhai-Pour" 1 2010 284 1685 4840 54679 9 9 1				
				13 "Ban" 1 2012 1982 13151 47258 390665 13 13 1	
				15 "Kjaesgaard" 1 2013 210 1674 110377 818426 15 15 1 
				16 "Andersen" 1 2014 2883 22884 139201 1256959 16 16 1	
				18 "Johansen" 1 2015 2359 20612 124333 1165124 18 18 1	
				20 "Almeida" 1 2016 165 1955 1685 28343 20 20 1
				25 "Kolding" 1 2021 134 4105 10739 353581 25 25 .
				26 "Ankarfeldt" 1 2021 . . . . 26 26 1
				27 "Kitchin" 1 2022 385 1205 15428 62658 27 27 1
				28 "Ostenfeld" 1 2022 237 1168 . . 28 28 1
				29 "Giner-Soriano" 1 2022 . . . . 29 29 1
				35 "Ban" 2 2012 1539 10132 47258 390665 35 35 1
				37 "Andersen" 2 2013 2883 22884 139201 1256956 37 37 1 
				38 "Johansen" 2 2015 . . . . 38 38 1
				41 "Kitchin" 2 2022 266 18070 597 54209 41 41 1
				46 "Ankarfeldt" 3 2021 143 1201 103367 984447 46 46 1

		end

	* Define labels for forest plot components 
	* trial (1,2,3...) to "Author (year)" 

		label define trial_lb 	9"*Nakhai-Pour {it:et al.}" ///
					13"*Ban {it:et al.}" ///
					15"*Kjaesgaard {it:et al.}" ///
					16"*Andersen {it:et al.}" ///
					18"*Johansen {it:et al.}" ///
					20"*Almeida {it:et al.}" ///
					25"Kolding {it:et al.}" ///
					26"*Ankarfeldt {it:et al.}" ///
					27"*Kitchin {it:et al.}" ///
					28"*Ostenfeld {it:et al.}" ///
					29"*Giner-Soriano {it:et al.}" ///
					35"*Ban {it:et al.}" ///
					37"*Andersen {it:et al.}" ///
					38"*Johansen {it:et al.}" ///
					41"*Kitchin {it:et al.}" ///
					46"*Ankarfeldt {it:et al.}"

		label values trial trial_lb

	* adtype (1,2,3) to groups on the forest plot "AD vs none" etc.

		label define adtype_lb 	1"Any antidepressants vs none" ///
					2"SSRIs vs none" ///
					3"SNRIs vs none"  
		
		label values adtype adtype_lb

	* nt (1,2,3...) to "Number of spontaneous abortion/total number of exposed"
	
		label define nt_lb 	9"284/1,685" ///
					13"1,982/13,151" ///
					15"210/1,674" ///
					16"2,883/22,884" ///
					18"2,359/20,612" ///
					20"165/1,955" ///
					25"134/4,105" ///
					26"143/1,201" ///
					27"385/1,205" ///
					28"237/1,168" ///
					29"NA" ///
					35"1,539/10,132" ///
					37"2,883/22/884" ///
					38"NA" ///
					41"266/18,070" ///
					46"143/1,201"
								
		label values nt nt_lb 

	* nc (1,2,3...) to "Number of spontaneous abortion/total number of controls"

		label define nc_lb 	9"4,840/54,679" ///
					13"47,258/390,665" ///
					15"110,377/818,426" ///
					16"139,201/1,256,956" ///
					18"124,333/1,165,124" ///
					20"1,685/28,343" ///
					25"10,739/353,581" ///
					26"103,367/984,447" ///
					27"15,428/62,658" ///
					28"NA" ///
					29"NA" ///
					35"47,258/390,665" ///
					37"139,201/1,256,956" ///
					38"NA" ///
					41"597/54,209" ///
					46"103,367/984,447"

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

		replace logor = log(1.38) if trial ==8 
		replace selogor = (((log(1.94))-(log(0.98)))/3.92) if trial ==8 // Einarson

		replace logor = log(1.68) if trial ==9
		replace selogor = (((log(2.06))-(log(1.38)))/3.92) if trial ==9 // Nakhai-Pour

		replace logor = log(1.54) if trial ==11
		replace selogor = (((log(2.2))-(log(1.1)))/3.92) if trial ==11 // Chan

		replace logor = log(1.07) if trial ==12
		replace selogor = (((log(2.24))-(log(0.51)))/3.92) if trial ==12 // Einarson

		replace logor = log(1.33) if trial ==13 
		replace selogor = (((log(1.5))-(log(1.19)))/3.92) if trial ==13 // Ban
		
		replace logor = log(1.27) if trial ==15
		replace selogor = (((log(1.33))-(log(1.22)))/3.92) if trial ==15 // Kjaesgaard
		
		replace logor = log(1.14) if trial ==16
		replace selogor = (((log(1.18))-(log(1.1)))/3.92) if trial ==16 // Andersen

		replace logor = log(1.2) if trial ==17
		replace selogor = (((log(1.46))-(log(0.98)))/3.92) if trial ==17 // Abadie

		replace logor = log(1.07) if trial ==18
		replace selogor = (((log(1.11))-(log(1.02)))/3.92) if trial ==18 // Johansen

		replace logor = log(1.3) if trial ==20
		replace selogor = (((log(1.5))-(log(1.1)))/3.92) if trial ==20 // Almeida

		replace logor = log(1.92) if trial ==21
		replace selogor = (((log(3.02))-(log(1.22)))/3.92) if trial ==21 // Evans-Hoeker

		replace logor = log(1.26) if trial ==22
		replace selogor = (((log(1.91))-(log(0.829)))/3.92) if trial ==22 // Richardson

		replace logor = log(1.34) if trial ==23
		replace selogor = (((log(1.85))-(log(0.97)))/3.92) if trial ==23 // Wu

		replace logor = log(1.89) if trial ==24
		replace selogor = (((log(3.43))-(log(1.04)))/3.92) if trial ==24 // Bahat
		
		replace logor = log(1.14) if trial ==26
		replace selogor = (((log(1.34))-(log(0.96)))/3.92) if trial ==26 // Ankarfeldt
		
		replace logor = log(1.29) if trial ==27
		replace selogor = (((log(1.46))-(log(1.13)))/3.92) if trial ==27 // Kitchin
		
		replace logor = log(1.04) if trial ==28
		replace selogor = (((log(1.20))-(log(0.91)))/3.92) if trial ==28 // Ostenfeld
		
		replace logor = log(1.11) if trial ==29
		replace selogor = (((log(1.16))-(log(1.06)))/3.92) if trial ==29 // Giner-Soriano

		replace logor = log(1.5) if trial ==35
		replace selogor = (((log(1.6))-(log(1.3)))/3.92) if trial ==35 // Ban

		replace logor = log(1.27) if trial ==37
		replace selogor = (((log(1.33))-(log(1.22)))/3.92) if trial ==37 // Anderen

		replace logor = log(1.07) if trial ==38
		replace selogor = (((log(1.11))-(log(1.02)))/3.92) if trial ==38 // Johansen

		replace logor = log(1.73) if trial ==39
		replace selogor = (((log(3))-(log(1)))/3.92) if trial ==39 // Evans-Hoeker

		replace logor = log(1.45) if trial ==40
		replace selogor = (((log(2.06))-(log(1.02)))/3.92) if trial ==40 // Wu
		
		replace logor = log(1.21) if trial ==41
		replace selogor = (((log(1.40))-(log(1.04)))/3.92) if trial ==41 // Kitchin

		replace logor = log(1.26) if trial ==44
		replace selogor = (((log(1.91))-(log(0.829)))/3.92) if trial ==44 // Richardson

		replace logor = log(1.89) if trial ==45
		replace selogor = (((log(3.43))-(log(1.04)))/3.92) if trial ==45 // Bahat
		
		replace logor = log(1.14) if trial ==46
		replace selogor = (((log(1.34))-(log(0.96)))/3.92) if trial ==46 // Ankarfeldt		


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

		replace _meta_studysize = 1874 if trial ==8
		replace _meta_studysize = 56364 if trial ==9
		replace _meta_studysize = 4536 if trial ==11
		replace _meta_studysize = 267 if trial ==12
		replace _meta_studysize = 331414 if trial ==13
		replace _meta_studysize = 1005319 if trial ==15
		replace _meta_studysize = 1279840 if trial ==16
		replace _meta_studysize = 5346 if trial ==17
		replace _meta_studysize = 1281418 if trial ==18
		replace _meta_studysize = 41964 if trial ==20
		replace _meta_studysize = 1650 if trial ==21
		replace _meta_studysize = 2529 if trial ==22
		replace _meta_studysize = 5451 if trial ==23
		replace _meta_studysize = 722 if trial ==24
		replace _meta_studysize = 1020288 if trial ==26
		replace _meta_studysize = 72280 if trial ==27
		replace _meta_studysize = 9500 if trial ==28
		replace _meta_studysize = 180692 if trial ==29
		replace _meta_studysize = 331414 if trial ==35
		replace _meta_studysize = 1279840 if trial ==37
		replace _meta_studysize = 1281418 if trial ==38
		replace _meta_studysize = 1650 if trial ==39
		replace _meta_studysize = 5451 if trial ==40
		replace _meta_studysize = 72280 if trial ==41
		replace _meta_studysize = 2529 if trial ==44
		replace _meta_studysize = 722 if trial ==45
		replace _meta_studysize = 1020288 if trial ==46

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

		forestplot, useopts nostats nowt rcols(_EFFECT _WT) graphregion(color(white)) xlab(0.4,1,9) name("Soph_analysis_RandR_v2_pxnonly", replace)
		
		graph export Soph_analysis_RandR_v2_pxnonly.pdf, name(Soph_analysis_RandR_v2_pxnonly) replace

*********************************************************************************************************

* Stop logging

	log close pxn_only
	
	translate "$Logdir\4_pxn only.smcl" "$Logdir\4_pxn only.pdf", replace
	
	erase "$Logdir\4_pxn only.smcl"

*********************************************************************************************************
