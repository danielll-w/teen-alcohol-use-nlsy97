clear

* load in gpa data
use gpa.dta

*merge other variables

merge 1:1 id year using age.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge 1:1 id year using alcohol.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge 1:1 id year using marijuana.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge 1:1 id year using hard_drugs.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge 1:1 id year using hh_income.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge m:1 id using parent_education.dta
drop if _merge == 2 | _merge == 1
drop _merge

merge m:1 id using highest_grade.dta
drop if _merge == 2 | _merge == 1
drop _merge

*other adjustments

replace race = race < 4
drop bday_m
drop bday_y
drop sample_type

*regressions

drop first_drank
drop ever_drank

*drop if year < 1997
drop if gpa_ == -6 | gpa == -4 | gpa == -7 | gpa == -8 | gpa == -9

replace days_drank_last_30_ = 0 if days_drank_last_30 == -4 | days_drank_last_30_ == -5 | days_drank_last_30_ == -2 | days_drank_last_30_ == -1

drop if age_int_date_ > 18 | age_int_date < 14

recode days_drank_last_30_ (0=0) (1/6=1) (7/21=2) (21/30=3)

*drop if days_drank_last_30_ == 0 | days_drank_last_30_ == 1

xtset id year
xtreg gpa i.days_drank_last_30_, fe r
xttest3 
eststo
xtreg gpa i.days_drank_last_30_ age_int_date i.year, fe
testparm i.year
eststo

esttab using FE_main.tex, replace drop(0.days_drank_last_30_) title(Fixed Effects Regressions table\label{tab1})
eststo clear    
