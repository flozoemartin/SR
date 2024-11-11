
***************************************************************************************************************************

* Antidepressant use during pregnancy and risk of stillbirth: a systematic review & meta-analysis - Runs all the global macros for the antidepressants and stillbirth meta-analysis. To be run at the start of all Stata sessions

* Author: Flo Martin 

* Date: 09/12/2021

***************************************************************************************************************************

clear 

global Projectdir "/location/of/project/files"

global Dodir 		"/location/of/dofiles"
global Logdir 		"$Projectdir/logfiles"
global Graphdir 	"$Projectdir/graphfiles"

cd "$Projectdir"

***************************************************************************************************************************
