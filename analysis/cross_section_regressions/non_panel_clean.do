clear

*load in marijuana data
use marijuana.dta

*merge rest of cleaned data for other variables
merge 1:1 id using highest_grade.dta
drop _merge

merge 1:1 id using race.dta
drop _merge

merge 1:1 id using hh_income.dta
drop _merge

merge 1:1 id using alcohol.dta
rename age_first_drank first_drank
drop _merge

merge 1:1 id using cigs.dta
rename age_smoked first_smoked_cig
drop _merge

merge 1:1 id using grades.dta
drop _merge

merge 1:1 id using hard_drugs.dta
rename age_first_hard first_hard
drop _merge

merge 1:1 id using parent_education.dta
drop _merge

merge 1:1 id using gpa.dta
drop _merge

merge 1:1 id using alcohol_freq.dta
drop _merge

merge 1:1 id using sex.dta
drop _merge

merge 1:1 id using first_age.dta
drop _merge

replace highest_grade = highest_grade >= 12
logit highest_grade 

*regressions

*rename mean_gpa_2 mean_gpa
*drop if missing(mean_gpa)

*Most important regression as we move to fixed effects
replace frequency_drank = 0 if missing(frequency_drank)
replace frequency_drank = round(frequency_drank)
recode frequency_drank (0=0) (1/6=1) (7/21=2) (21/30=3)

*summary statistics
replace hh_income = . if hh_income < 1000
replace sex = 0 if sex == 1
replace sex = 1 if sex == 2
replace race = 1 if race < 4
replace race = 0 if race == 4
estpost tabstat mean_gpa frequency_drank sex race first_age ever_cig ever_hard ever_use_mj highest_grade parent_ed hh_income, listwise statistics(mean sd) columns(statistics)
esttab using descriptive_stats.tex, cells("mean sd") nomtitle nonumber noobs replace title(Regression table\label{tab1})

eststo clear

replace ever_drank = 0 if first_drank > 18
reg mean_gpa ever_drank, r
reg mean_gpa ever_drank race, r
reg mean_gpa ever_drank race parent_ed sex hh_income, r


*full regression table
reg mean_gpa i.frequency_drank, r
eststo
reg mean_gpa i.frequency_drank race, r
eststo
reg mean_gpa i.frequency_drank sex, r
eststo
reg mean_gpa i.frequency_drank ever_cig ever_hard ever_use_mj, r
eststo
reg mean_gpa i.frequency_drank hh_income, r
eststo
reg mean_gpa i.frequency_drank parent_ed, r
eststo
reg mean_gpa i.frequency_drank race sex ever_cig ever_hard ever_use_mj hh_income parent_ed, r
eststo

eststo clear
logit highest_grade ever_use_mj
esttab using logit.tex

esttab

esttab using OLS_main.tex, replace drop(0.frequency_drank)
eststo clear

*partial regression table

quietly reg mean_gpa i.frequency_drank, r
eststo
hettest
ovtest
quietly reg mean_gpa i.frequency_drank race, r
eststo
hettest
rvfplot
ovtest
quietly reg mean_gpa i.frequency_drank sex, r
eststo
rvfplot
ovtest
quietly reg mean_gpa i.frequency_drank ever_cig ever_hard ever_use_mj, r
eststo
rvfplot
ovtest
quietly reg mean_gpa i.frequency_drank parent_ed, r
eststo
rvfplot
ovtest
quietly reg mean_gpa i.frequency_drank hh_income, r
eststo
rvfplot
ovtest
quietly reg mean_gpa i.frequency_drank race sex ever_cig ever_hard ever_use_mj hh_income parent_ed, r
ovtest
rvfplot
eststo

esttab

esttab using OLS_extended.tex, replace drop(0.frequency_drank) title(Regression table\label{tab1}) ar2
eststo clear

drop if first_drank > 18
drop ever_drank
reg mean_gpa first_drank, r

