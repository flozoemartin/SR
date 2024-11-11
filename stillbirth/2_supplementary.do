
****************************************************************************************************************************

* Systematic review supplementary material figures do-file: meta-analysis & sensitivity analyses

* Author: Flo Martin

* Date: 09/12/2021

****************************************************************************************************************************

* Start logging

	log using "$Logdir\2_supplementary", name(supplementary) replace
	
****************************************************************************************************************************

	cd "$Graphdir"

* Supplementary Figure 1 - removing all critical studies

	* First, build a dataframe with the raw numbers from each paper for the general population comparisons:

	* nt = total number of treated

	* nc = total number of controls

	* sbt = number of stillbirths in treated

	* sbc = number of stillbirths in controls
	
	* total_t = total number of treated
	
	* total_c = total number of controls

	* Make the dataframe with the raw numbers (for the columns)

		clear
		input trial adtype year nt nc sbt sbc total_t total_c
			
			1 3 2019 281 1405 3 12 1 1
			2 1 2011 178 89 4 1 2 2 
			3 4 2004 91 89 1 1 3 3 
			4 4 2003 147 147 0 1 4 4 
			6 2 2005 132 132 2 1 6 6
			7 2 2013 29228 1604649 135 5919 7 7
			8 3 2007 732 860215 6 3197 8 8
			9 2 2006 972 3878 11 17 9 9 
			10 2 2013 6378 908214 42 3844 10 10
			13 2 2012 212 212 3 2 13 13

		end
	
	* Define labels for trial numbers in the dataframe with labels that show "Author et al."

		label define trialid_lb 1"Richardson {it:et al.}" ///
					2"Einarson {it:et al.}" ///
					3"Chun-Fai-Chan {it:et al.}" /// 
					4"Einarson {it:et al.}" ///
					6"Sivojelezova {it:et al.}" ///
					7"*Stephansson {it:et al.}" ///
					8"*Lennestal {it:et al.}" ///
					9"*Wen {it:et al.}" ///
					10"*Jimenez-Solem {it:et al.}" ///
					13"Klieger-Grossman {it:et al.}" 	
	
	* Label trial with respective labels
	
		label values trial trialid_lb

	* Define labels for antidepressant type in the dataframe with labels that show "AD type" 
		
		label define group_lb 1"Any antidepressants" ///
					2"Selective serotonin reuptake inhibitors (SSRI)" ///
					3"Serotonin noradrenaline reuptake inhibitors (SNRI)" /// 
					4"Atypical antidepressants"
	
	* Label adtype with respective labels
							  
		label values adtype group_lb
		
	* Define labels for total treated in the dataframe with labels that show "number of stillbirths in treated/total number of treated" 

		label define total_t_lb 1"3/281" ///
					2"4/178" ///	
					3"1/91" ///
					4"0/147" ///
					6"2/132" ///
					7"135/29228" ///
					8"6/732" ///
					9"11/972" ///	
					10"42/6378" ///
					13"3/212" 		
								
	* Label total_t with respective labels							
								
		label values total_t total_t_lb

	* Define labels for total controls in the dataframe with labels that show "number of stillbirths in controls/total number of controls" 		

		label define total_c_lb 1"12/1405" ///
					2"1/89" ///
					3"1/89" ///
					4"1/147" ///
					6"1/132" ///
					7"5919/1604649" ///
					8"3197/860215" ///
					9"17/3878" ///
					10"3844/908214" ///	
					13"2/212" 		

	* Label total_c with respective labels								
								
		label values total_c total_c_lb

	* Derive number who did not experience a stillbirth

	* hc = number of non-stillbirths in controls

	* ht = number of non-stillbirths in treated 

		generate hc=nc-sbc
		generate ht=nt-sbt

		list sbt ht nt sbc hc nc

	* Calculat the log odds from raw numbers

		gen logor=log((sbt/ht)/(sbc/hc))

	* Calculate the standard error from the raw numbers

		gen selogor=sqrt(1/sbt+1/ht+1/sbc+1/hc)

	* Calculate the 95%CIs from the log odds and SE

		gen lci=exp(logor-(1.96*selogor))
		gen uci=exp(logor+(1.96*selogor))

	* Now use meta esize using these numbers to generate the metadata dataframe
		
		meta esize sbt ht sbc hc 

	* Now fill in the blanks with the best estimates

		replace _meta_es = .6729445 if trial ==2
		replace _meta_es = .1570037 if trial ==7
		replace _meta_es = .5306283 if trial ==8
		replace _meta_es = .8020016 if trial ==9
		replace _meta_es = .0582689 if trial ==10

		replace _meta_se = .9045354 if trial ==2
		replace _meta_se = .0980642 if trial ==7
		replace _meta_se = .4570815 if trial ==8
		replace _meta_se = .4044359 if trial ==9
		replace _meta_se = .20406 if trial ==10

		replace _meta_cil = log(.3328895) if trial ==2
		replace _meta_cil = log(.9654103) if trial ==7
		replace _meta_cil = log(.6940221) if trial ==8
		replace _meta_cil = log(1.009351) if trial ==9
		replace _meta_cil = log(.7105694) if trial ==10

		replace _meta_ciu = log(11.54017) if trial ==2
		replace _meta_ciu = log(1.417946) if trial ==7
		replace _meta_ciu = log(4.164133) if trial ==8
		replace _meta_ciu = log(4.926831) if trial ==9
		replace _meta_ciu = log(1.581267) if trial ==10

		replace _meta_studysize = 267 if trial ==2
		replace _meta_studysize = 1512798 if trial ==7
		replace _meta_studysize = 672255 if trial ==8
		replace _meta_studysize = 4850 if trial ==9
		replace _meta_studysize = 786128 if trial ==10

	* Then produce the meta-analysis forest plot

		admetan _meta_es _meta_se, eform by(adtype) nowt label(namevar=trial, yearvar=year) ///
		lcols(total_t total_c) forest(hetstat(p) leftj) ///
		saving(supp_fig_1, replace)

		use supp_fig_1, clear
		label var _LABELS `"{bf:Study author (year)}"'
		replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0

		label var total_t `"`"{bf:Treated}"' `"n/N"'"'
		label var total_c `"`"{bf:Controls}"' `"n/N"'"'
		label var _EFFECT `"`"{bf:Odds ratio}"' `"{bf:(95% CI)}"'"'
		label var _WT `"`"{bf:Weight}"' `"{bf:%}"'"'
		
		drop if _USE==3 & _BY==1

		forestplot, useopts nostats rcols(_EFFECT _WT) xlab(0.01,1,20) ///
		graphregion(color(white)) ///
		name("supp_fig_1", replace)
		
	* Save Supplementary Figure 1
		
		graph export supp_fig_1.pdf, name(supp_fig_1) replace

****************************************************************************************************************************

* Supplementary Figure 2 - removing all critical and serious studies

	* First, build a dataframe with the raw numbers from each paper for the general population comparisons:

		clear
		input trial adtype year nt nc sbt sbc total_t total_c
			
			2 1 2011 178 89 4 1 2 2 
			3 4 2004 91 89 1 1 3 3 
			7 2 2013 29228 1604649 135 5919 7 7
			8 3 2007 732 860215 6 3197 8 8
			9 2 2006 972 3878 11 17 9 9 
			10 2 2013 6378 908214 42 3844 10 10
			13 2 2012  212 212 3 2 13 13

		end
	
	* Define labels for trial numbers in the dataframe with labels that show "Author et al."

		label define trialid_lb 2"Einarson {it:et al.}" ///
					3"Chun-Fai-Chan {it:et al.}" /// 
					7"*Stephansson {it:et al.}" ///
					8"*Lennestal {it:et al.}" ///
					9"*Wen {it:et al.}" ///
					10"*Jimenez-Solem {it:et al.}" ///
					13"Klieger-Grossman {it:et al.}" 	
	
	* Label trial with respective labels
	
		label values trial trialid_lb

	* Define labels for antidepressant type in the dataframe with labels that show "AD type" 
		
		label define group_lb 1"Any antidepressants" ///
					2"Selective serotonin reuptake inhibitors (SSRI)" ///
					3"Serotonin noradrenaline reuptake inhibitors (SNRI)" /// 
					4"Atypical antidepressants"
	
	* Label adtype with respective labels
							  
		label values adtype group_lb
		
	* Define labels for total treated in the dataframe with labels that show "number of stillbirths in treated/total number of treated" 

		label define total_t_lb 2"4/178" ///	
					3"1/91" ///
					7"135/29228" ///
					8"6/732" ///
					9"11/972" ///	
					10"42/6378" ///
					13"3/212" 		
								
	* Label total_t with respective labels							
								
		label values total_t total_t_lb

	* Define labels for total controls in the dataframe with labels that show "number of stillbirths in controls/total number of controls" 		

		label define total_c_lb 2"1/89" ///
					3"1/89" ///
					7"5919/1604649" ///
					8"3197/860215" ///
					9"17/3878" ///
					10"3844/908214" ///	
					13"2/212" 		

	* Label total_c with respective labels								
								
		label values total_c total_c_lb

	* Derive number who did not experience a stillbirth

	* hc = number of non-stillbirths in controls

	* ht = number of non-stillbirths in treated 

		generate hc=nc-sbc
		generate ht=nt-sbt

		list sbt ht nt sbc hc nc

	* Calculat the log odds from raw numbers

		gen logor=log((sbt/ht)/(sbc/hc))

	* Calculate the standard error from the raw numbers

		gen selogor=sqrt(1/sbt+1/ht+1/sbc+1/hc)

	* Calculate the 95%CIs from the log odds and SE

		gen lci=exp(logor-(1.96*selogor))
		gen uci=exp(logor+(1.96*selogor))

	* Now use meta esize using these numbers to generate the metadata dataframe
		
		meta esize sbt ht sbc hc 

	* Now fill in the blanks with the best estimates

		replace _meta_es = .6729445 if trial ==2
		replace _meta_es = .1570037 if trial ==7
		replace _meta_es = .5306283 if trial ==8
		replace _meta_es = .8020016 if trial ==9
		replace _meta_es = .0582689 if trial ==10

		replace _meta_se = .9045354 if trial ==2
		replace _meta_se = .0980642 if trial ==7
		replace _meta_se = .4570815 if trial ==8
		replace _meta_se = .4044359 if trial ==9
		replace _meta_se = .20406 if trial ==10

		replace _meta_cil = log(.3328895) if trial ==2
		replace _meta_cil = log(.9654103) if trial ==7
		replace _meta_cil = log(.6940221) if trial ==8
		replace _meta_cil = log(1.009351) if trial ==9
		replace _meta_cil = log(.7105694) if trial ==10

		replace _meta_ciu = log(11.54017) if trial ==2
		replace _meta_ciu = log(1.417946) if trial ==7
		replace _meta_ciu = log(4.164133) if trial ==8
		replace _meta_ciu = log(4.926831) if trial ==9
		replace _meta_ciu = log(1.581267) if trial ==10

		replace _meta_studysize = 267 if trial ==2
		replace _meta_studysize = 1512798 if trial ==7
		replace _meta_studysize = 672255 if trial ==8
		replace _meta_studysize = 4850 if trial ==9
		replace _meta_studysize = 786128 if trial ==10

	* Then produce the meta-analysis forest plot

		admetan _meta_es _meta_se, eform by(adtype) nowt label(namevar=trial, yearvar=year) ///
		lcols(total_t total_c) forest(hetstat(p) leftj) ///
		saving(supp_fig_2, replace)

		use supp_fig_2, clear
		label var _LABELS `"{bf:Study author (year)}"'
		replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0

		label var total_t `"`"{bf:Treated}"' `"n/N"'"'
		label var total_c `"`"{bf:Controls}"' `"n/N"'"'
		label var _EFFECT `"`"{bf:Odds ratio}"' `"{bf:(95% CI)}"'"'
		label var _WT `"`"{bf:Weight}"' `"{bf:%}"'"'

		drop if _USE==3 & (_BY==1 | _BY==3 | _BY==4)

		forestplot, useopts nostats rcols(_EFFECT _WT) xlab(0.01,1,20) 	///
		graphregion(color(white)) ///
		name("supp_fig_2", replace)
		
	* Save Supplementary Figure 2
		
		graph export supp_fig_2.pdf, name(supp_fig_2) replace
 
****************************************************************************************************************************

* Stop logging

	log close supplementary
	
	translate "$Logdir\2_supplementary.smcl" "$Logdir\2_supplementary.pdf", replace
	
	erase "$Logdir\2_supplementary.smcl"
	
****************************************************************************************************************************
