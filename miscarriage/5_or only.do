
*********************************************************************************************************************

* Sensitivity analysis restricting to studies that reported ORs only to assess the impact of combining ORs, RRs, and HRs

* Author: Flo Martin

* Date: 29/10/2023

*********************************************************************************************************************

* Start logging

	log using "$Logdir\5_or only", name(or_only) replace

*********************************************************************************************************************

* Change working directory for saving figures

	cd "$Graphdir"

	* Make the dataframe out of the raw data where possible - for those with just OR(95%CI) provided in the paper put '.' (missing) to fill in later:

		clear

			input float trial str20 author adtype year rt ht rc hc nt nc adj

				1 "Chambers" 1 1996 23 169 22 254 1 1 .
				2 "Kulin" 1 1998 30 267 21 267 2 2 .
				3 "Einarson" 1 2001 18 150 11 150 3 3 .
				4 "Einarson" 1 2003 20 147 12 147 4 4 .
				5 "Sivojelezova" 1 2005 14 132 13 132 5 5 . 
				6 "Chun-Fai-Chan" 1 2005 20 136 6 133 6 6 .
				7 "Djulus" 1 2006 20 104 11 104 7 7 .	
				9 "Nakhai-Pour" 1 2010 284 1685 4840 54679 9 9 1				
				10 "Paulus" 1 2010 23 202 81 714 10 10
				11 "Chan" 1 2011 . . . . 11 11 1
				12 "Einarson" 1 2011 8 89 8 89 12 12 1
				14 "Klieger-Grossman" 1 2012 32 213 18 212 14 14 .			
				17 "Abadie" 1 2015 170 899 668 4447 17 17 1		
				19 "Te Winkel" 1 2016 85 732 46 730 19 19
				22 "Richardson" 1 2019 46 281 140 1405 22 22 1
				25 "Kolding" 1 2021 134 4105 10739 353581 25 25 .
				26 "Ankarfeldt" 1 2021 . . . . 26 26 1
				27 "Kitchin" 1 2022 385 1205 15428 62658 27 27 1
				29 "Giner-Soriano" 1 2022 . . . . 29 29 1
				30 "Chambers" 2 1996 23 169 22	254 30 30 .
				31 "Kulin" 2 1998 30 267 21	267 31 31 .
				34 "Paulus" 2 2010 23 202 81 714 34 34 .
				36 "Klieger-Grossman" 2 2012 32 213 18 212 36 36 .
				42 "Einarson" 3 2001 18 150 11	150 42 42 .
				43 "Te Winkel" 3 2016 85 732 46	730 43 43 .
				44 "Richardson" 3 2019 46 281 140 1405 44 44 1
				46 "Ankarfeldt" 3 2021 143 1201 103367 984447 46 46 1

		end

	* Define labels for forest plot components 
	* trial (1,2,3...) to "Author (year)" 

		label define trial_lb 	1"Chambers {it:et al.}" ///
					2"Kulin {it:et al.}" ///
					3"Einarson {it:et al.}" ///
					4"Einarson {it:et al.}" ///
					5"Sivojelezova {it:et al.}" ///
					6"Chun-Fai-Chan {it:et al.}" ///
					7"Djulus {it:et al.}" ///
					9"*Nakhai-Pour {it:et al.}" ///
					10"Paulus {it:et al.}" ///
					11"*Chan {it:et al.}" ///
					12"*Einarson {it:et al.}" ///
					14"Klieger-Grossman {it:et al.}" ///
					17"*Abadie {it:et al.}" ///
					19"Te Winkel {it:et al.}" ///
					22"*Richardson {it:et al.}" ///
					25"Kolding {it:et al.}" ///
					26"*Ankarfeldt {it:et al.}" ///
					27"*Kitchin {it:et al.}" ///
					29"*Giner-Soriano {it:et al.}" ///
					30"Chambers {it:et al.}" ///
					31"Kulin {it:et al.}" ///
					34"Paulus {it:et al.}" ///
					36"Klieger-Grossman {it:et al.}" ///
					42"Einarson {it:et al.}" ///
					43"Te Winkel {it:et al.}" ///
					44"*Richardson {it:et al.}" ///
					46"*Ankarfeldt {it:et al.}"

		label values trial trial_lb

	* adtype (1,2,3) to groups on the forest plot "AD vs none" etc.

		label define adtype_lb 	1"Any antidepressants vs none" ///
					2"SSRIs vs none" ///
					3"SNRIs vs none"  
		
		label values adtype adtype_lb

	* nt (1,2,3...) to "Number of spontaneous abortion/total number of exposed"
	
		label define nt_lb 	1"23/169" /// 
					2"30/267" ///
					3"18/150" ///
					4"20/147" ///
					5"14/132" ///
					6"20/136" ///
					7"20/104" ///
					8"122/937" ///
					9"284/1,685" ///
					10"23/202" ///
					11"NA" ///
					12"8/89" ///
					13"1,982/13,151" ///
					14"32/213" ///
					15"210/1,674" ///
					16"2,883/22,884" ///
					17"170/889" ///
					18"2,359/20,612" ///
					19"85/732" ///
					20"165/1,955" ///
					21"16/90" ///
					22"46/281" ///
					23"42/223" ///
					24"NA" ///
					25"134/4,105" ///
					26"143/1,201" ///
					27"385/1,205" ///
					28"" ///
					29"NA" ///
					30"23/169" ///
					31"30/267" ///
					32"16/150" ///
					33"14/132" ///
					34"23/202" ///
					35"1,539/10,132" ///
					36"32/213" ///
					37"2,883/22/884" ///
					38"NA" ///
					39"11/57" ///
					40"35/179" ///
				 	41"" ///
					42"18/150" ///
					43"85/732" ///
					44"46/281" ///
					45"NA" ///
					46"143/1,201"
								
		label values nt nt_lb 

	* nc (1,2,3...) to "Number of spontaneous abortion/total number of controls"

		label define nc_lb 	1"22/254" /// 
					2"21/267" ///
					3"11/150" ///
					4"12/147" ///
					5"13/132" ///
					6"6/133" ///
					7"11/104" ///
					8"75/937" ///
					9"4,840/54,679" ///
					10"81/714" ///
					11"NA" ///
					12"8/89" ///
					13"47,258/390,665" ///
					14"18/21" ///
					15"110,377/818,426" ///
					16"139,201/1,256,956" ///
					17"668/4,447" ///
					18"124,333/1,165,124" ///
					19"46/730" ///
					20"1,685/28,343" ///
					21"118/1,484" ///
					22"140/1,405" ///
					23"617/5,228" ///
					24"NA" ///
					25"10,739/353,581" ///
					26"103,367/984,447" ///
					27"15,428/62,658" ///
					28"" ///
					29"NA" ///
					30"22/254" ///
					31"21/267" ///
					32"11/150" ///
					33"13/132" ///
					34"91/714" ///
					35"47,258/390,665" ///
					36"18/212" ///
					37"139,201/1,256,956" ///
					38"NA" ///
					39"118/1,484" ///
					40"617/5,228" ///
					41"" ///
					42"11/150" ///
					43"46/730" ///
					44"140/1,405" ///
					45"NA" ///
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

		replace logor = log(1.68) if trial ==9
		replace selogor = (((log(2.06))-(log(1.38)))/3.92) if trial ==9 // Nakhai-Pour

		replace logor = log(1.54) if trial ==11
		replace selogor = (((log(2.2))-(log(1.1)))/3.92) if trial ==11 // Chan

		replace logor = log(1.07) if trial ==12
		replace selogor = (((log(2.24))-(log(0.51)))/3.92) if trial ==12 // Einarson

		replace logor = log(1.2) if trial ==17
		replace selogor = (((log(1.46))-(log(0.98)))/3.92) if trial ==17 // Abadie

		replace logor = log(1.26) if trial ==22
		replace selogor = (((log(1.91))-(log(0.829)))/3.92) if trial ==22 // Richardson
		
		replace logor = log(1.14) if trial ==26
		replace selogor = (((log(1.34))-(log(0.96)))/3.92) if trial ==26 // Ankarfeldt
		
		replace logor = log(1.29) if trial ==27
		replace selogor = (((log(1.46))-(log(1.13)))/3.92) if trial ==27 // Kitchin
		
		replace logor = log(1.11) if trial ==29
		replace selogor = (((log(1.16))-(log(1.06)))/3.92) if trial ==29 // Giner-Soriano

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

		replace _meta_studysize = 56364 if trial ==9
		replace _meta_studysize = 4536 if trial ==11
		replace _meta_studysize = 1243 if trial ==12
		replace _meta_studysize = 5346 if trial ==17
		replace _meta_studysize = 2529 if trial ==22
		replace _meta_studysize = 1020288 if trial ==26
		replace _meta_studysize = 72280 if trial ==27
		replace _meta_studysize = 180692 if trial ==29
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

		forestplot, useopts nostats nowt rcols(_EFFECT _WT) graphregion(color(white)) xlab(0.4,1,9) name("Soph_analysis_RandR_v2_oronly", replace)
		
		graph export Soph_analysis_randr_v2_oronly.pdf, name(Soph_analysis_RandR_v2_oronly) replace

*********************************************************************************************************

* Stop logging

	log close or_only
	
	translate "$Logdir\5_or only.smcl" "$Logdir\5_or only.pdf", replace
	
	erase "$Logdir\5_or only.smcl"

*********************************************************************************************************
